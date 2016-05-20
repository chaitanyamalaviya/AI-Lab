user_edit(File) :-
   name(File, FileString),
   name('vim ', TextEditString), %% Edit this line for your favorite editor
   append(TextEditString, FileString, EDIT),
   name(E,EDIT),
   shell(E).
