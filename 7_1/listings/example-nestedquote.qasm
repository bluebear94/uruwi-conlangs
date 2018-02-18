# Clause #1
  literal v1 "neb" # = compensate
  setvopt past
  pronoun near # Subject
  pronoun far # Object
  sentence # Join sentence
  conn conditional 0 "a" # connector
  attachconn
# Clause #2
  literal v2 "fuz" # = capture
  setvopt past
  setaspect perf
  literal nsent "nabusun^g" # = chairperson
  setnopt def
  literal nsent "f^xoton^g" # = criminal
  setnopt def
  sentence
# Clause #3
  literal v3 "c" # = allow
  setvopt past
  pronoun near # Subject
  pronounlc # Object
  sentence
# Clause #4
  literal v1 "tag" # = escape
  setvopt past
  # In this sense, the O is the escaper.
  literal nsent "f^xoton^g" # = criminal
  setnopt def
  sentence ns # Omit the subject
# Clause #5
  literal v3 "c" # = allow
  setvopt past
  literal nsent "maza" # = person
  setnopt def
  pronounlc # Object
  sentence
# Clause #6
  literal v3 "m" # = return to
  setvopt past q
  pronoun anaph_sub # Subject
  literal nabst "skofl" # = role; Object
  # Push a node representing "lifelong slavery"
  literal nabst "wat^sa" # = slavery
  literal dback "unun" # = lifelong
  modadj # Modify
  # Attach it by genitive
  modgen
  sentence
# Clause #7
  literal v3 "c" # = allow
  setvopt past q
  literal nsent "maza" # = person
  setnopt def
  pronounlc
  sentence
  conn conditional 0 "a" # connector
  attachconn

