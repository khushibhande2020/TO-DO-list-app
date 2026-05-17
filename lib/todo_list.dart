import'package:flutter/material.dart';
import 'dart:developer';
import'package:google_fonts/google_fonts.dart';
import 'package:to_do_list_app/database.dart';
import 'package:to_do_list_app/todo_model.dart';
import 'package:intl/intl.dart';

class TodoAppUI extends StatefulWidget{
  const TodoAppUI({super.key});

  @override
  State createState() => _TodoAppUIState();
}

class _TodoAppUIState extends State{
   TextEditingController titleController =TextEditingController();
   TextEditingController descriptionController =TextEditingController();
   TextEditingController dateController =TextEditingController();

   List<ToDoModel> todoCards =[];

  List cardColorsList = [
    Color.fromRGBO(250, 232, 232, 1),
    Color.fromRGBO(232, 237, 250, 1),
    Color.fromRGBO(250, 249, 232, 1),
    Color.fromRGBO(250, 232, 250, 1),
  ];
  @override
  void initState(){
    super.initState();
    getData();
  }
  void getData() async{
    List<Map> cardList = await TodoDatabase().getTodoItems();
    log("CARD LIST: $cardList");
    for(var element in cardList){
      todoCards.add(
        ToDoModel(
          title: element['title'], 
          description:element['description'] , 
          date: element['date'], 
          id: element['id']
        ),
      );
    }
   setState(() {});
   log("Todo list: $todoCards");
   log("Todo list length: ${todoCards.length}");
  }

  void clearController(){
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    } 
    void submit (bool doEdit, [ToDoModel? obj]){
      if (titleController.text.isNotEmpty && 
      descriptionController.text.isNotEmpty && 
      dateController.text.isNotEmpty){
        if(doEdit){
          //EDIT
          obj!.title =titleController.text;
          obj.description =descriptionController.text;
          obj.date =dateController.text;
          Map<String, dynamic> mapObj ={
            'title':obj.title,
            'description':obj.description,
            'date': obj.date,
            'id':obj.id,
          };
          TodoDatabase().updateTodoItem(mapObj);
          }else{
            //ADD
            todoCards.add(
              ToDoModel(
                title :titleController.text,
                description :descriptionController.text,
                date :dateController.text,
                 ),
            );
            Map<String, dynamic> dataMap={
              'title':titleController.text,
              'description':descriptionController.text,
              'date': dateController.text,
            };
            TodoDatabase().insertTodoItem(dataMap);
          }
          clearController();
          Navigator.of(context).pop();
          setState((){});
      }
    }

   showBottomSheet(bool doEdit, [ToDoModel? obj]){
  return  showModalBottomSheet(
      context: context,
     builder: (context){
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create to-do Task",
                  style: GoogleFonts.quicksand(
                    fontSize:22,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          SizedBox(height:10),

          Text(
            "Title",
            style: GoogleFonts.quicksand(
              fontSize: 18,
              color: Color.fromRGBO(2, 167, 177, 1),
            ),
          ),

          //title
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Color.fromRGBO(2, 167, 177, 1),
                ),
              ),
              hintText: "Enter title",
            ),
          ),
          SizedBox(height:10),
            Text(
              "Description",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                color: Color.fromRGBO(2, 167, 177, 1),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(2, 167, 177, 1),
                  ),
                ),
                 hintText: "Enter description",
              ),
            ),

            SizedBox(height:10),
            Text(
              "Date",
              style:GoogleFonts.quicksand(
                fontSize: 18,
                color:Color.fromRGBO(2, 167, 177, 1),
              ),
            ),
             TextField(
              controller: dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(2, 167, 177, 1),
                  ),
                ),
                 hintText: "select date",
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              onTap: () async{
                DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(2025),lastDate: DateTime(2026),
                );
                dateController.text = DateFormat.yMMMd().format(pickedDate!);
              },
             ),
             SizedBox(height:10),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ElevatedButton(
                    onPressed: () {
                   if(doEdit == true){
                    submit(true, obj);
                   }else{
                    submit(false);
                   }
                    },
                     style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromRGBO(2, 167, 177, 1),
                      ),
                      
                     ),
                     child:Text("submit", style:GoogleFonts.quicksand(fontSize: 12,
                      fontWeight:FontWeight.w500,color:Color.fromRGBO(255, 255, 255, 1),),),
                 ),
              ],
             ),
             SizedBox(height:30),
          ],
        ),
      );
    },
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 167, 177, 1),
        title: Text(
          "To-do List",
          style: GoogleFonts.quicksand( 
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Color.fromRGBO(255, 255, 255, 1.0),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: todoCards.length,
        itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardColorsList[index % cardColorsList.length],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(height:10),
                      Container(
                        padding:EdgeInsets.all(5),
                        margin:EdgeInsets.all(7),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child:Image.network("https://static.vecteezy.com/system/resources/previews/021/040/389/original/to-do-list-icon-vector.jpg",
                          // Image.network("https://static.vecteezy.com/system/resources/previews/003/529/153/non_2x/business-to-do-list-flat-icon-modern-style-vector.jpg", 
                          fit: BoxFit.cover),
                          ),
                      ),
                      SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start ,
                          children: [
                            Text(
                              todoCards[index].title,
                              style:GoogleFonts.quicksand(fontSize: 16, fontWeight:FontWeight.w700,color:Color.fromRGBO(0, 0, 0, 1)),
                            ),
                            Text(
                              todoCards[index].description,
                              style:GoogleFonts.quicksand(fontSize: 12, fontWeight:FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding:EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                         todoCards[index].date,
                          style:GoogleFonts.quicksand(fontSize: 12, fontWeight:FontWeight.w300),
                        ),
                        Spacer(),
                        GestureDetector(onTap: (){
                          titleController.text=todoCards[index].title;
                          descriptionController.text=todoCards[index].description;
                         dateController.text=todoCards[index].date;
                              showBottomSheet(true, todoCards[index]);
                        },
                        child: Icon(Icons.edit_outlined,  
                        color: Color.fromRGBO(2, 167, 177, 1),
                        ),
                       ),
                       SizedBox(width:10),
                       GestureDetector (
                        onTap:(){
                          int id = todoCards[index].id;
                          todoCards.removeAt(index);
                          TodoDatabase().deleteTodoItem(id);
                          setState(() {});
                        },
                        child:Icon(Icons.delete_outline_rounded, color: Color.fromRGBO(2, 167, 177, 1),
                        ),  
                       ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          clearController();
          showBottomSheet(false);
        },
        backgroundColor: Color.fromRGBO(2, 167, 177, 1),
        child: Icon(Icons.add,color:Colors.white),
        ),
    );
  }
}