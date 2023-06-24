# THIS FILE DEFINES A LIBRARY TARGET

// Get started: Add a module with name api with mkdir src/api
// And add a mod.rei file to it. Watch it Rein

ExecutionTask[Ret]: {
    value: Ret?
    name: String
    task: [Any] -> Ret
}

execute (args, task: ExecutionTask[Ret]): task.task(args)



GraphicsData: {
    width: Int
    height: Int
    title: String
}
