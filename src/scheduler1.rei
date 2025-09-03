// quick scheduling mechanism

processes = [[job1, id1, memory], [job2, id2, memory]].

list3 ls = ≡ (length ls) 3.

listof [ls] = ls.

processes ps = pre (listof |> list3 ps).

random = name.

schedule ps = pick-one (policy := random) ps.

pick-one policy ps = match [
  random ?> std.rand |> get _ ps
].
