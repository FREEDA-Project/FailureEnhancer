% Deployment
deployedTo(webfrontend, large, n1).
deployedTo(backend, medium, n2).
deployedTo(database, large, n2).
deployedTo(mobilefrontend, medium, n3).

% Backend internal failure and database unreachable
unreachable(database, 6).
internal(backend, 7).

% webfrontend failed to contact the backend
timeoutEvent(frontend, backend, 8).

% n2 overloaded and n3 disconnected
overloaded(n2, cpu, 5, 10).
disconnected(n3, 3, 4).

% Network congestion between n2 and n3 affecting communication
congested(n2, n3, 8, 10).

% mobilefrontend failed to contact the backend
timeoutEvent(mobilefrontend, backend, 9).