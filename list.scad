function has_item(val, list) =
  0 == len(list)
  ? false
  : (val == list[0])
    ? true
    : has_item(val, tail(list));

function tail(v) = [
  let (end = len(v))
    for (i = [1:1:end - 1])
      v[i]
];
