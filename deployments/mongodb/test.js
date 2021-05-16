db = db.getSiblingDB("todosdb")
db.todos.insertOne({"title": "Deploy standalone MongoDB on K8s", "complete": true});
db.todos.insertOne({"title": "Deploy standalone Redis on K8s", "complete": false});
db.todos.insertOne({"title": "Deploy standalone Postgres on K8s", "complete": false});
db.todos.insertOne({"title": "Deploy standalone SQL Server on K8s", "complete": false});
db.todos.insertOne({"title": "Deploy standalone Kafka on K8s", "complete": false});
db.todos.insertOne({"title": "Deploy standalone MinIO on K8s", "complete": false});
cursor = db.todos.find({"complete": true}, {"_id":0});
while(cursor.hasNext()) {
   printjson(cursor.next());
}
