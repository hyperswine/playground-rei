// handle the Render effect. Applies tail recursive optimization
render: handle Render (scene: Scene) -> ()
  render (update_scene scene)

// main way to exit the rendering
user_exit_request_handler: handle UserExitEffect () -> ()
  std.process.exit 0

scene1: Scene (objects: [cube, sphere, light])
scene2: rotate (scene1, cube, 45)
