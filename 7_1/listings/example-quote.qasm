# Clause #1: I have known Vladimir for 12 years.
  literal v2 "mun" # = know (a person)
  setvopt past
  setaspect imp
  literal 0 "ne" # preposition
  literal nmeas "bane" # = year
  pushint 12
  modnoun
  adptov
  pronoun near # Subject
  literal 0 "vladimic" # Object
  setnname
  sentence
# Clause #2: You have known Vladimir for 12/2 years.
  literal v2 "mun" # = know (a person)
  setvopt past
  setaspect imp
  literal 0 "ne" # preposition
  literal nmeas "bane" # = year
  pushint 12
  pushint 2
  div
  modnoun
  adptov
  pronoun far # Subject
  pronoun anaph_obj # Object
  sentence
# Clause #3: Maria could have taken the opportunity to quit the Assembly without repercussions.
  literal v3 "virlast" # = leave (an organisation)
  setvopt past
  setaspect epis_pot perf
  literal dfront "pcen" # = by opportunity
  modverb
  literal dfront "filmap" # = without repercussions
  modverb
  literal 0 "maci.a" # name
  setnname
  literal nabst "malna" # = assembly
  setnopt def
  sentence
# Clause #4: She could have announced (...).
  literal v1 "rev" # = say
  setvopt past
  setaspect epis_pot perf
  pronoun anaph_sub
  # Generated from example-nestedquote.qasm.
  # I might support a macro that does this automatically.
  literal nsent "tq.enebpa.isu.asu.itiba.obite.efuzpa.ipi.q.a.atqtinabusun^gso.qtq.of^xoton^gso.qtitu.icpa.isu.afatitq.etagpa.itq.of^xoton^gso.qtatu.icpa.itq.umazaso.qfatitu.impatesu.use.oskoflse.uwat^sasa.uunun.i.etitu.icpatetq.umazaso.qfatiba.obi"
  sentence
# Clause #5: Vladimir let either one of the above happen.
  literal v3 "c" # = allow
  literal 0 "vladimic" # Subject
  setnname
  # Object:
  pronounlc
  pronounllc
  literal 0 "z" # = or
  conj
  # End
  sentence
  conn subversive 0 "p"
  attachconn
# Clause #6: She dared to listen to Vladimir.
  literal v1 "vens" # = listen
  setvopt past
  literal dback ".adaz" # = dare to
  modverb
  literal 0 "maci.a" # name, Subject
  setnname
  pronoun anaph_sub # Object
  sentence
  conn explanatory 0 "a"
  attachconn
# Clause #7: Therefore, she was ridiculed by her brothers.
  literal v1 "k^xa." # = ridicule
  setvopt past
  literal nsent "fqlto" # = sibling (du)
  setnopt inv
  pronoun anaph_sub # Object
  sentence
  conn explanatory 0 "a"
  attachconn
  conn subversive 0 "p"
  attachconn
# Clause #8: I found the above surprising.
  literal v1 "mej" # = surprise
  setvopt past
  pronounlc
  pronoun far
  sentence
# Clause #9: I do not find it surprising right now.
  literal v1 "mej" # = surprise
  setvopt neg
  literal dfront "mif" # = now
  modverb
  pronounllc
  pronoun far
  sentence
