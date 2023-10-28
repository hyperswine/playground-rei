
read_item: Http.Get "/items/{item_id}" (item_id: Int, q: String?) -> JSONObject
  JSONObject {
    "item_id": item_id
    "q": q  
  }

fetch_resources: Http.Get "/resources" -> JSONObject
  image: cloud_storage.get "image.png"
  db_data: db.get_data
  JSONObject {
    "image": image
    "data": db_data
  }

// handle_db_error: handle HttpError500 error -> Http.Response 
//   Http.Response {
//     status: 500,
//     body: JSONObject { "error": "Database Error" }
//   }

// the thing is, there is an automatic dataflow. Maybe you dont actually care about the dataflow. in that case, you could just do
// nowait

HttpError: effect ErrorCode

DBOperation: effect DBError

get_user: Http.Get "/user/{user_id}" (user_id: Int) -> JSONObject // throws DBOperation
  user: db.get_user user_id
  user ?
    JSONObject {
      "id": user.id
      "name": user.name
    } :
    throw (HttpError NotFound)

// middleware can just be hooks? before?
log_request: before run (req: ref HttpRequest) -> HttpRequest throws LoggingError
  logging_service.log req ?
    req :
    throw (LoggingError "Failed to log request")

update_user: Http.Put "/user/{user_id}" (user_id: Int, data: UserData) -> JSONObject // throws DBOperation | ValidationEffect
  (db.update_user user_id data) ? 
    JSONObject { "message": "User updated successfully" } :
    throw (HttpError BadRequest)
