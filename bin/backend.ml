(* ll ir compilation -------------------------------------------------------- *)

open Ll
open X86

module Platform = Util.Platform

(* Overview ----------------------------------------------------------------- *)

(* We suggest that you spend some time understanding this entire file and
   how it fits with the compiler pipeline before making changes.  The suggested
   plan for implementing the compiler is provided on the project web page.
*)


(* helpers ------------------------------------------------------------------ *)

(* Map LL comparison operations to X86 condition codes *)
let compile_cnd = function
  | Ll.Eq  -> X86.Eq
  | Ll.Ne  -> X86.Neq
  | Ll.Slt -> X86.Lt
  | Ll.Sle -> X86.Le
  | Ll.Sgt -> X86.Gt
  | Ll.Sge -> X86.Ge



(* locals and layout -------------------------------------------------------- *)

(* One key problem in compiling the LLVM IR is how to map its local
   identifiers to X86 abstractions.  For the best performance, one
   would want to use an X86 register for each LLVM %uid.  However,
   since there are an unlimited number of %uids and only 16 registers,
   doing so effectively is quite difficult.  We will see later in the
   course how _register allocation_ algorithms can do a good job at
   this.

   A simpler, but less performant, implementation is to map each %uid
   in the LLVM source to a _stack slot_ (i.e. a region of memory in
   the stack).  Since LLVMlite, unlike real LLVM, permits %uid locals
   to store only 64-bit data, each stack slot is an 8-byte value.

   [ NOTE: For compiling LLVMlite, even i1 data values should be
   represented as a 8-byte quad. This greatly simplifies code
   generation. ]

   We call the datastructure that maps each %uid to its stack slot a
   'stack layout'.  A stack layout maps a uid to an X86 operand for
   accessing its contents.  For this compilation strategy, the operand
   is always an offset from %rbp (in bytes) that represents a storage slot in
   the stack.
*)

type layout = (uid * X86.operand) list

(* A context contains the global type declarations (needed for getelementptr
   calculations) and a stack layout. *)
type ctxt = { tdecls : (tid * ty) list
            ; layout : layout
            }

(* useful for looking up items in tdecls or layouts *)
let lookup m x = List.assoc x m


(* compiling operands  ------------------------------------------------------ *)

(* LLVM IR instructions support several kinds of operands.

   LL local %uids live in stack slots, whereas global ids live at
   global addresses that must be computed from a label.  Constants are
   immediately available, and the operand Null is the 64-bit 0 value.

     NOTE: two important facts about global identifiers:

     (1) You should use (Platform.mangle gid) to obtain a string
     suitable for naming a global label on your platform (OS X expects
     "_main" while linux expects "main").

     (2) 64-bit assembly labels are not allowed as immediate operands.
     That is, the X86 code: movq _gid %rax which looks like it should
     put the address denoted by _gid into %rax is not allowed.
     Instead, you need to compute an %rip-relative address using the
     leaq instruction:   leaq _gid(%rip) %rax.

   One strategy for compiling instruction operands is to use a
   designated register (or registers) for holding the values being
   manipulated by the LLVM IR instruction. You might find it useful to
   implement the following helper function, whose job is to generate
   the X86 instruction that moves an LLVM operand into a designated
   destination (usually a register).
*)
let compile_operand (ctxt:ctxt) (dest:X86.operand) : Ll.operand -> ins =
  function 
  | Const i -> (Movq, [ Imm (Lit i); dest ])
  | Null -> (Movq, [ Imm (Lit 0L); dest ])
  | Gid gid -> 
    (* Global identifier: load address using leaq with RIP-relative addressing *)
    (Leaq, [ Ind3 (Lbl (Platform.mangle gid), Rip); dest ])
  | Id uid -> 
    (* Local identifier: move from stack slot to destination *)
    let stack_slot = List.assoc uid ctxt.layout in
    (Movq, [ stack_slot; dest ])



(* compiling call  ---------------------------------------------------------- *)

(* You will probably find it helpful to implement a helper function that
   generates code for the LLVM IR call instruction.

   The code you generate should follow the x64 System V AMD64 ABI
   calling conventions, which places the first six 64-bit (or smaller)
   values in registers and pushes the rest onto the stack.  Note that,
   since all LLVM IR operands are 64-bit values, the first six
   operands will always be placed in registers.  (See the notes about
   compiling fdecl below.)

   [ NOTE: Don't forget to preserve caller-save registers (only if needed). ]

   [ NOTE: Remember, call can use labels as immediates! You shouldn't need to 
     perform any RIP-relative addressing for this one. ]

   [ NOTE: It is the caller's responsibility to clean up arguments pushed onto
     the stack, so you must free the stack space after the call returns. (But 
     see below about alignment.) ]

   [ NOTE: One important detail about the ABI besides the conventions is that, 
  at the time the [callq] instruction is invoked, %rsp *must* be 16-byte aligned.  
  However, because LLVM IR provides the Alloca instruction, which can dynamically
  allocate space on the stack, it is hard to know statically whether %rsp meets
  this alignment requirement.  Moroever: since, according to the calling 
  conventions, stack arguments numbered > 6 are pushed to the stack, we must take
  that into account when enforcing the alignment property.  

  We suggest that, for a first pass, you *ignore* %rsp alignment -- only a few of 
  the test cases rely on this behavior.  Once you have everything else working,
  you can enforce proper stack alignment at the call instructions by doing 
  these steps: 
    1. *before* pushing any arguments of the call to the stack, ensure that the
    %rsp is 16-byte aligned.  You can achieve that with the x86 instruction:
    `andq $-16, %rsp`  (which zeros out the lower 4 bits of %rsp, possibly 
    "allocating" unused padding space on the stack)

    2. if there are an *odd* number of arguments that will be pushed to the stack
    (which would break the 16-byte alignment because stack slots are 8 bytes),
    allocate an extra 8 bytes of padding on the stack. 
    
    3. follow the usual calling conventions - any stack arguments will still leave
    %rsp 16-byte aligned

    4. after the call returns, in addition to freeing up the stack slots used by
    arguments, if there were an odd number of slots, also free the extra padding. 
    
  ]
*)




(* compiling getelementptr (gep)  ------------------------------------------- *)

(* The getelementptr instruction computes an address by indexing into
   a datastructure, following a path of offsets.  It computes the
   address based on the size of the data, which is dictated by the
   data's type.

   To compile getelementptr, you must generate x86 code that performs
   the appropriate arithmetic calculations.
*)

(* [size_ty] maps an LLVMlite type to a size in bytes.
    (needed for getelementptr)

   - the size of a struct is the sum of the sizes of each component
   - the size of an array of t's with n elements is n * the size of t
   - all pointers, I1, and I64 are 8 bytes
   - the size of a named type is the size of its definition

   - Void, i8, and functions have undefined sizes according to LLVMlite.
     Your function should simply return 0 in those cases
*)
let rec size_ty (tdecls:(tid * ty) list) (t:Ll.ty) : int =
  match t with
  | I1 -> 8                    (* i1 is represented as 8-byte quad *)
  | I64 -> 8                   (* i64 is 8 bytes *)
  | Ptr _ -> 8                 (* All pointers are 8 bytes *)
  | Struct tys -> 
      (* Struct size is sum of all member sizes *)
      List.fold_left (fun acc ty -> acc + size_ty tdecls ty) 0 tys
        | Array (_n, ty) ->
          (* Array size is number of elements * size of each element *)
          _n * size_ty tdecls ty
  | Namedt tid -> 
      (* Named type: look up the definition in tdecls *)
      size_ty tdecls (List.assoc tid tdecls)
  | Void | I8 | Fun _ -> 0     (* Undefined sizes, return 0 *)




(* Generates code that computes a pointer value.

   1. op must be of pointer type: t*

   2. the value of op is the base address of the calculation

   3. the first index in the path is treated as the index into an array
     of elements of type t located at the base address

   4. subsequent indices are interpreted according to the type t:

     - if t is a struct, the index must be a constant n and it
       picks out the n'th element of the struct. [ NOTE: the offset
       within the struct of the n'th element is determined by the
       sizes of the types of the previous elements ]

     - if t is an array, the index can be any operand, and its
       value determines the offset within the array.

     - if t is any other type, the path is invalid

   5. if the index is valid, the remainder of the path is computed as
      in (4), but relative to the type f the sub-element picked out
      by the path so far
*)
let compile_gep (ctxt:ctxt) (op : Ll.ty * Ll.operand) (path: Ll.operand list) : ins list =
  let (base_ty, base_op) = op in
  
  (* Load the base pointer into %rax *)
  let load_base = compile_operand ctxt (Reg Rax) base_op in
  
  (* Helper function to take first n elements of a list *)
  let rec take n lst =
    if n <= 0 then [] else
    match lst with
    | [] -> []
    | x :: xs -> x :: take (n-1) xs
  in
  
  (* Process each index in the path *)
  let rec process_path current_ty indices acc =
    match indices with
    | [] -> acc  (* No more indices, we're done *)
    | index_op :: rest_indices ->
        match current_ty with
        | Ptr ty ->
            (* First index: array indexing into the pointed-to type *)
            let load_index = compile_operand ctxt (Reg Rcx) index_op in
            let element_size = size_ty ctxt.tdecls ty in
            let multiply = (Imulq, [ Imm (Lit (Int64.of_int element_size)); Reg Rcx ]) in
            let add_offset = (Addq, [ Reg Rcx; Reg Rax ]) in
            let new_acc = acc @ [load_index; multiply; add_offset] in
            process_path ty rest_indices new_acc
            
        | Array (_n, ty) ->
            (* Array indexing: multiply index by element size *)
            let load_index = compile_operand ctxt (Reg Rcx) index_op in
            let element_size = size_ty ctxt.tdecls ty in
            let multiply = (Imulq, [ Imm (Lit (Int64.of_int element_size)); Reg Rcx ]) in
            let add_offset = (Addq, [ Reg Rcx; Reg Rax ]) in
            let new_acc = acc @ [load_index; multiply; add_offset] in
            process_path ty rest_indices new_acc
            
        | Struct tys ->
            (* Struct field access: index must be a constant *)
            (match index_op with
            | Const field_idx ->
                let field_idx_int = Int64.to_int field_idx in
                if field_idx_int >= 0 && field_idx_int < List.length tys then
                  (* Calculate offset to the field *)
                  let field_offset = 
                    take field_idx_int tys 
                    |> List.fold_left (fun acc ty -> acc + size_ty ctxt.tdecls ty) 0
                  in
                  let add_offset = (Addq, [ Imm (Lit (Int64.of_int field_offset)); Reg Rax ]) in
                  let field_ty = List.nth tys field_idx_int in
                  let new_acc = acc @ [add_offset] in
                  process_path field_ty rest_indices new_acc
                else
                  failwith "Invalid struct field index"
            | _ -> failwith "Struct field index must be a constant")
            
        | Namedt tid ->
            (* Named type: look up the definition and continue *)
            let actual_ty = List.assoc tid ctxt.tdecls in
            process_path actual_ty indices acc
            
        | _ -> failwith "Invalid getelementptr path: cannot index into this type"
  in
  
  (* Start processing from the base type *)
  process_path base_ty path [load_base]



(* compiling instructions  -------------------------------------------------- *)

(* The result of compiling a single LLVM instruction might be many x86
   instructions.  We have not determined the structure of this code
   for you. Some of the instructions require only a couple of assembly
   instructions, while others require more.  We have suggested that
   you need at least compile_operand, compile_call, and compile_gep
   helpers; you may introduce more as you see fit.

   Here are a few notes:

   - Icmp:  the Setb instruction may be of use.  Depending on how you
     compile Cbr, you may want to ensure that the value produced by
     Icmp is exactly 0 or 1.

   - Load & Store: these need to dereference the pointers. Const and
     Null operands aren't valid pointers.  Don't forget to
     Platform.mangle the global identifier.

   - Alloca: needs to return a pointer into the stack

   - Bitcast: does nothing interesting at the assembly level
*)
let compile_insn (ctxt:ctxt) ((uid:uid), (i:Ll.insn)) : X86.ins list =
  match i with
  | Binop (bop, _ty, op1, op2) ->
    (* Get the destination stack slot for this instruction *)
    let dest_slot = List.assoc uid ctxt.layout in
    
    (* Load first operand into %rax *)
    let load_op1 = compile_operand ctxt (Reg Rax) op1 in
    
    (* Load second operand into %rcx *)
    let load_op2 = compile_operand ctxt (Reg Rcx) op2 in
    
    (* Perform the binary operation *)
    let binop_insn = match bop with
      | Add -> (Addq, [ Reg Rcx; Reg Rax ])
      | Sub -> (Subq, [ Reg Rcx; Reg Rax ])
      | Mul -> (Imulq, [ Reg Rcx; Reg Rax ])
      | Shl -> (Shlq, [ Reg Rcx; Reg Rax ])
      | Lshr -> (Shrq, [ Reg Rcx; Reg Rax ])
      | Ashr -> (Sarq, [ Reg Rcx; Reg Rax ])
      | And -> (Andq, [ Reg Rcx; Reg Rax ])
      | Or -> (Orq, [ Reg Rcx; Reg Rax ])
      | Xor -> (Xorq, [ Reg Rcx; Reg Rax ])
    in
    
    (* Store result back to stack slot *)
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    
    (* Combine all instructions *)
    [ load_op1; load_op2; binop_insn; store_result ]
  
  | Gep (ty, op, path) ->
    (* Get the destination stack slot for this instruction *)
    let dest_slot = List.assoc uid ctxt.layout in
    
    (* Compile the getelementptr operation *)
    let gep_instructions = compile_gep ctxt (ty, op) path in
    
    (* Store the result to the destination *)
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    
    (* Combine all instructions *)
    gep_instructions @ [store_result]
  
  | Alloca _ty ->
    (* Alloca: allocate stack space and return pointer to it *)
    (* We need to allocate new space on the stack for this alloca *)
    (* For now, let's use a simple approach: allocate space below the current stack *)
    let dest_slot = List.assoc uid ctxt.layout in
    (* Decrement stack pointer to allocate space *)
    let allocate_space = (Subq, [ Imm (Lit 8L); Reg Rsp ]) in
    (* Load the current stack pointer (which now points to the allocated space) *)
    let load_addr = (Movq, [ Reg Rsp; Reg Rax ]) in
    (* Store the address to the destination *)
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    [ allocate_space; load_addr; store_result ]
  
  | Load (_ty, ptr) ->
    (* Load: load value from memory into register *)
    let dest_slot = List.assoc uid ctxt.layout in
    (* Load the pointer into %rcx *)
    let load_ptr = compile_operand ctxt (Reg Rcx) ptr in
    (* Load the value from memory into %rax *)
    let load_value = (Movq, [ Ind2 Rcx; Reg Rax ]) in
    (* Store the result to destination *)
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    [ load_ptr; load_value; store_result ]
  
  | Store (_ty, value, ptr) ->
    (* Store: store value from register into memory *)
    (* Load the value into %rax *)
    let load_value = compile_operand ctxt (Reg Rax) value in
    (* Load the pointer into %rcx *)
    let load_ptr = compile_operand ctxt (Reg Rcx) ptr in
    (* Store the value to memory *)
    let store_to_mem = (Movq, [ Reg Rax; Ind2 Rcx ]) in
    [ load_value; load_ptr; store_to_mem ]
  
  | Icmp (cnd, _ty, op1, op2) ->
    (* Icmp: integer comparison - sets condition codes and stores result *)
    let dest_slot = List.assoc uid ctxt.layout in
    
    (* Load first operand into %rax *)
    let load_op1 = compile_operand ctxt (Reg Rax) op1 in
    
    (* Load second operand into %rcx *)
    let load_op2 = compile_operand ctxt (Reg Rcx) op2 in
    
    (* Compare the operands *)
    let compare_insn = (Cmpq, [ Reg Rcx; Reg Rax ]) in
    
    (* Set the result based on the condition *)
    (* First, clear %rax to 0 *)
    let clear_rax = (Movq, [ Imm (Lit 0L); Reg Rax ]) in
    
    (* Then set to 1 if condition is true *)
    let set_result = match cnd with
      | Eq -> (Set Eq, [ Reg Rax ])    (* Set if equal *)
      | Ne -> (Set Neq, [ Reg Rax ])   (* Set if not equal *)
      | Slt -> (Set Lt, [ Reg Rax ])   (* Set if signed less than *)
      | Sle -> (Set Le, [ Reg Rax ])   (* Set if signed less than or equal *)
      | Sgt -> (Set Gt, [ Reg Rax ])   (* Set if signed greater than *)
      | Sge -> (Set Ge, [ Reg Rax ])   (* Set if signed greater than or equal *)
    in
    
    (* Store the result to destination *)
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    
    (* Combine all instructions *)
    [ load_op1; load_op2; compare_insn; clear_rax; set_result; store_result ]
  
  | Call (_ret_ty, fn_op, args) ->
    (* Call: function call with x64 System V AMD64 ABI *)
    let dest_slot = List.assoc uid ctxt.layout in
    
    (* Save caller-save registers if needed *)
    (* Don't save %rax since we need it for the function address *)
    let save_regs = [
      (Pushq, [ Reg Rcx ]);
      (Pushq, [ Reg Rdx ]);
      (Pushq, [ Reg Rsi ]);
      (Pushq, [ Reg Rdi ]);
      (Pushq, [ Reg R08 ]);
      (Pushq, [ Reg R09 ]);
    ] in
    
    (* Load function address into %rax *)
    let load_fn = compile_operand ctxt (Reg Rax) fn_op in
    
    (* Set up arguments in registers (first 6 arguments) *)
    let register_args = 
      List.mapi (fun i (_arg_ty, arg_op) ->
        if i < 6 then
          (* First 6 arguments go in registers *)
          let reg = match i with
            | 0 -> Reg Rdi
            | 1 -> Reg Rsi  
            | 2 -> Reg Rdx
            | 3 -> Reg Rcx
            | 4 -> Reg R08
            | 5 -> Reg R09
            | _ -> failwith "Too many register arguments"
          in
          [compile_operand ctxt reg arg_op]
        else
          (* Skip stack arguments - they'll be handled separately *)
          []
      ) args
      |> List.flatten
    in
    
    (* Set up stack arguments (arguments 6 and beyond) *)
    let stack_args = 
      (* Manually filter arguments with index >= 6 *)
      let rec filteri_impl i lst =
        match lst with
        | [] -> []
        | x :: xs -> 
            if i >= 6 then x :: filteri_impl (i+1) xs
            else filteri_impl (i+1) xs
      in
      let stack_arg_list = filteri_impl 0 args in
      (* Push stack arguments in reverse order *)
      List.rev stack_arg_list
      |> List.map (fun (_arg_ty, arg_op) ->
          (* Load argument into %rax first *)
          let load_arg = compile_operand ctxt (Reg Rax) arg_op in
          (* Push to stack *)
          let push_arg = (Pushq, [ Reg Rax ]) in
          [load_arg; push_arg]
        )
      |> List.flatten
    in
    
    (* Make the call *)
    let call_insn = (Callq, [ Reg Rax ]) in
    
    (* Clean up stack arguments (if any) *)
    let num_stack_args = List.length args - 6 in
    let cleanup_stack = 
      if num_stack_args > 0 then
        (* Add 8 bytes per stack argument to %rsp *)
        [ (Addq, [ Imm (Lit (Int64.of_int (num_stack_args * 8))); Reg Rsp ]) ]
      else
        []
    in
    
    (* Restore caller-save registers *)
    (* Don't restore %rax since it contains the return value *)
    let restore_regs = [
      (Popq, [ Reg R09 ]);
      (Popq, [ Reg R08 ]);
      (Popq, [ Reg Rdi ]);
      (Popq, [ Reg Rsi ]);
      (Popq, [ Reg Rdx ]);
      (Popq, [ Reg Rcx ]);
    ] in
    
    (* Store the return value to destination *)
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    
    (* Combine all instructions *)
    save_regs @ register_args @ stack_args @ [load_fn; call_insn] @ cleanup_stack @ restore_regs @ [store_result]

  | Bitcast (_ty1, op, _ty2) ->
    (* Bitcast: type cast - just copy the pointer value *)
    let dest_slot = List.assoc uid ctxt.layout in
    let load_ptr = compile_operand ctxt (Reg Rax) op in
    let store_result = (Movq, [ Reg Rax; dest_slot ]) in
    [load_ptr; store_result]



(* compiling terminators  --------------------------------------------------- *)

(* prefix the function name [fn] to a label to ensure that the X86 labels are 
   globally unique . *)
let mk_lbl (fn:string) (l:string) = fn ^ "." ^ l

(* Compile block terminators is not too difficult:

   - Ret should properly exit the function: freeing stack space,
     restoring the value of %rbp, and putting the return value (if
     any) in %rax.

   - Br should jump

   - Cbr branch should treat its operand as a boolean conditional

   [fn] - the name of the function containing this terminator
*)
let compile_terminator (fn:string) (ctxt:ctxt) (t:Ll.terminator) : ins list =
  match t with
  | Ret (Void, None) ->
    (* ret void: restore stack and return without a value *)
    [ (Movq, [ Reg Rbp; Reg Rsp ]);  (* Restore %rsp *)
      (Popq, [ Reg Rbp ]);           (* Restore old %rbp *)
      (Retq, []) ]
  | Ret (_, None) ->
    (* ret with no value (shouldn't happen in well-formed code) *)
    [ (Movq, [ Reg Rbp; Reg Rsp ]);  (* Restore %rsp *)
      (Popq, [ Reg Rbp ]);           (* Restore old %rbp *)
      (Retq, []) ]
  | Ret (_, Some operand) ->
    (* ret with value: put return value in %rax, restore stack, and return *)
    let move_to_rax = compile_operand ctxt (Reg Rax) operand in
    [ move_to_rax ] @
    [ (Movq, [ Reg Rbp; Reg Rsp ]);  (* Restore %rsp *)
      (Popq, [ Reg Rbp ]);           (* Restore old %rbp *)
      (Retq, []) ]
  | Br lbl ->
    (* Unconditional branch *)
    [ Jmp, [ Imm (Lbl (mk_lbl fn lbl)) ] ]
  | Cbr (cond, lbl1, lbl2) ->
    (* Conditional branch *)
    (* Load the condition operand into %rax *)
    let load_cond = compile_operand ctxt (Reg Rax) cond in
    (* Compare with 0 *)
    let compare_zero = (Cmpq, [ Imm (Lit 0L); Reg Rax ]) in
    (* Branch: if condition is 0 (false), go to lbl2, otherwise go to lbl1 *)
    let branch_false = (J Eq, [ Imm (Lbl (mk_lbl fn lbl2)) ]) in
    let branch_true = (Jmp, [ Imm (Lbl (mk_lbl fn lbl1)) ]) in
    [ load_cond; compare_zero; branch_false; branch_true ]


(* compiling blocks --------------------------------------------------------- *)

(* We have left this helper function here for you to complete. 
   [fn] - the name of the function containing this block
   [ctxt] - the current context
   [blk]  - LLVM IR code for the block
*)
let compile_block (fn:string) (ctxt:ctxt) (blk:Ll.block) : ins list =
  let { insns; term } = blk in
  
  (* Compile all instructions in the block *)
  let insn_code = List.map (fun (uid, insn) -> compile_insn ctxt (uid, insn)) insns |> List.flatten in
  
  (* Compile the terminator *)
  let term_code = compile_terminator fn ctxt (snd term) in
  
  (* Combine instruction code and terminator code *)
  insn_code @ term_code

let compile_lbl_block fn lbl ctxt blk : elem =
  Asm.text (mk_lbl fn lbl) (compile_block fn ctxt blk)



(* compile_fdecl ------------------------------------------------------------ *)


(* Complete this helper function, which computes the location of the nth incoming
   function argument: either in a register or relative to %rbp,
   according to the calling conventions. We will test this function as part of
   the hidden test cases.

   You might find it useful for compile_fdecl.

   [ NOTE: the first six arguments are numbered 0 .. 5 ]
*)
let arg_loc (n : int) : operand =
  match n with
  | 0 -> Reg Rdi  (* First argument in %rdi *)
  | 1 -> Reg Rsi  (* Second argument in %rsi *)
  | 2 -> Reg Rdx  (* Third argument in %rdx *)
  | 3 -> Reg Rcx  (* Fourth argument in %rcx *)
  | 4 -> Reg R08  (* Fifth argument in %r8 *)
  | 5 -> Reg R09  (* Sixth argument in %r9 *)
  | n when n > 5 -> 
    (* Arguments beyond the 6th go on the stack at positive offsets from %rbp *)
    (* Stack layout: [return address][old %rbp][arg6][arg7][arg8]... *)
    (* So arg6 is at %rbp + 16, arg7 at %rbp + 24, etc. *)
    Ind3 (Lit (Int64.of_int (16 + (n - 6) * 8)), Rbp)
  | _ -> failwith "Invalid argument number"


(* We suggest that you create a helper function that computes the
   stack layout for a given function declaration.

   - each function argument should be copied into a stack slot
   - in this (inefficient) compilation strategy, each local id
     is also stored as a stack slot.
   - see the discussion about locals

*)
let stack_layout (args : uid list) ((block, lbled_blocks):cfg) : layout =
  (* Collect all local identifiers from the function *)
  let collect_uids { insns; term = _term } =
    let insn_uids = List.map fst insns in
    (* let term_uid = fst term in
    insn_uids @ [term_uid] *)
    insn_uids
  in
  
  let all_uids = 
    let entry_uids = collect_uids block in
    let labeled_uids = List.map (fun (_, blk) -> collect_uids blk) lbled_blocks |> List.flatten in
    entry_uids @ labeled_uids
  in
  
  (* Create layout for stack arguments first (parameters 6+) *)
  (* Stack arguments are at positive offsets from %rbp and are NOT copied *)
  let stack_arg_layout = 
    let rec create_stack_args i params acc =
      match params with
      | [] -> acc
      | param :: rest when i >= 6 ->
          (* Stack argument at positive offset: 16 + (i-6)*8 *)
          let offset = 16 + (i - 6) * 8 in
          let stack_slot = Ind3 (Lit (Int64.of_int offset), Rbp) in
          create_stack_args (i+1) rest ((param, stack_slot) :: acc)
      | _ :: rest -> create_stack_args (i+1) rest acc
    in
    create_stack_args 0 args []
  in
  
  (* Create layout for register arguments and local variables *)
  (* Register arguments (0-5) are copied to negative offsets *)
  let register_params = 
    let rec take n lst = 
      match n, lst with
      | 0, _ -> []
      | _, [] -> []
      | n, x :: xs -> x :: take (n-1) xs
    in
    take (min 6 (List.length args)) args
  in
  let all_uids_with_params = register_params @ all_uids in
  
  (* Remove duplicates and sort for consistent ordering *)
  let unique_uids = List.sort_uniq String.compare all_uids_with_params in
  
  (* Create stack layout: each uid gets a unique stack slot *)
  (* Stack grows downward, so we use negative offsets from %rbp *)
  let rec create_layout uids offset acc =
    match uids with
    | [] -> acc
    | uid :: rest -> 
      let stack_slot = Ind3 (Lit (Int64.of_int offset), Rbp) in
      create_layout rest (offset - 8) ((uid, stack_slot) :: acc)
  in
  
  let local_layout = create_layout unique_uids (-8) [] in
  
  (* Combine stack argument layout and local layout *)
  stack_arg_layout @ local_layout

(* The code for the entry-point of a function must do several things:

   - since our simple compiler maps local %uids to stack slots,
     compiling the control-flow-graph body of an fdecl requires us to
     compute the layout (see the discussion of locals and layout)

   - the function code should also comply with the calling
     conventions, typically by moving arguments out of the parameter
     registers (or stack slots) into local storage space.  For our
     simple compilation strategy, that local storage space should be
     in the stack. (So the function parameters can also be accounted
     for in the layout.)

   - the function entry code should allocate the stack storage needed
     to hold all of the local stack slots.
*)
let compile_fdecl (tdecls:(tid * ty) list) (name:string) ({ f_param; f_cfg; _ }:fdecl) : prog =
  (* Create stack layout for this function *)
  let layout = stack_layout f_param f_cfg in
  
  (* Create context with type declarations and layout *)
  let ctxt = { tdecls; layout } in
  
  (* Function prologue: set up stack frame *)
  let prologue = [
    (Pushq, [ Reg Rbp ]);                    (* Save old %rbp *)
    (Movq, [ Reg Rsp; Reg Rbp ]);            (* Set new %rbp *)
  ] in
  
  (* Copy function arguments from registers to local stack slots *)
  (* Only copy register arguments (first 6) - stack arguments are accessed directly *)
  let copy_args = 
    let register_params = 
      let rec take n lst = 
        match n, lst with
        | 0, _ -> []
        | _, [] -> []
        | n, x :: xs -> x :: take (n-1) xs
      in
      take (min 6 (List.length f_param)) f_param
    in
    List.mapi (fun i param_uid ->
      let arg_loc = arg_loc i in
      let param_slot = List.assoc param_uid layout in
      (Movq, [ arg_loc; param_slot ])
    ) register_params
  in
  
  (* Calculate stack space needed for local variables *)
  let num_locals = List.length layout in
  let stack_space = num_locals * 8 in
  
  (* Allocate stack space for local variables *)
  let allocate_stack = 
    if stack_space > 0 then
      [ (Subq, [ Imm (Lit (Int64.of_int stack_space)); Reg Rsp ]) ]
    else
      []
  in
  
  (* Compile the function body *)
  let (entry_block, labeled_blocks) = f_cfg in
  let entry_code = compile_block name ctxt entry_block in
  let labeled_code = List.map (fun (lbl, blk) -> compile_lbl_block name lbl ctxt blk) labeled_blocks in
  
  (* Combine all code *)
  let all_instructions = prologue @ copy_args @ allocate_stack @ entry_code in
  
  (* Create the function element *)
  let func_elem = Asm.gtext (Platform.mangle name) all_instructions in
  
  (* Return function element plus any labeled blocks *)
  func_elem :: labeled_code



(* compile_gdecl ------------------------------------------------------------ *)
(* Compile a global value into an X86 global data declaration and map
   a global uid to its associated X86 label.
*)
let rec compile_ginit : ginit -> X86.data list = function
  | GNull     -> [Quad (Lit 0L)]
  | GGid gid  -> [Quad (Lbl (Platform.mangle gid))]
  | GInt c    -> [Quad (Lit c)]
  | GString s -> [Asciz s]
  | GArray gs | GStruct gs -> List.map compile_gdecl gs |> List.flatten
  | GBitcast (_t1,g,_t2) -> compile_ginit g

and compile_gdecl (_, g) = compile_ginit g


(* compile_prog ------------------------------------------------------------- *)
let compile_prog {tdecls; gdecls; fdecls; _} : X86.prog =
  let g = fun (lbl, gdecl) -> Asm.data (Platform.mangle lbl) (compile_gdecl gdecl) in
  let f = fun (name, fdecl) -> compile_fdecl tdecls name fdecl in
  (List.map g gdecls) @ (List.map f fdecls |> List.flatten)
