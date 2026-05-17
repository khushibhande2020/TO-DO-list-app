class ToDoModel {
  String title;
  String description;
  String date;
  int id;
   
   ToDoModel({
    required this.title,
    required this.description,
    required this.date,
    this.id=0,
   });
}