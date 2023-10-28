
read_item: Http.Get "/items/{item_id}" (item_id: Int, q: String?) -> JSONObject
  JSONObject {
    "item_id": item_id
    "q": q  
  }

fetch_resources: Http.Get "/resources" -> JSONObject
  image: cloud_storage.get("image.png")
  data: db.get_data()
  JSONObject {
    "image": image,
    "data": data
  }

handle_db_error: handle HttpError500 error -> Http.Response 
  Http.Response {
    status: 500,
    body: JSONObject { "error": "Database Error" }
  }

HttpError: effect ErrorCode

DBOperation: effect DBError

get_user: Http.Get "/user/{user_id}" (user_id: Int) -> JSONObject // throws DBOperation
  user: db.get_user user_id
  // the thing is, there is an automatic dataflow. Maybe you dont actually care about the dataflow. in that case, you could just do
  // nowait
  if not user
    throw (HttpError NotFound)
  JSONObject {
    "id": user.id
    "name": user.name
  }

