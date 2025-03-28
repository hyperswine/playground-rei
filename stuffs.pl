:- op(800, xfx, =>).

term_expansion((Head => Body), (NewHead :- Body)) :-
    Head =.. [Name|Args],
    % Get the output argument (last one)
    last(Args, Output),
    % Remove output from normal args
    append(NormalArgs, [Output], Args),
    % Construct new head with output as last argument
    append([Name], NormalArgs, PartialNewHead),
    append(PartialNewHead, [Output], NewHeadList),
    NewHead =.. NewHeadList.

% add(A, B) C => C is A + B.

    % This would expand to:
    % add(A, B, C) :- C is A + B.

% square(X) Y => Y is X * X.

    % This would expand to:
    % square(X, Y) :- Y is X * X.
