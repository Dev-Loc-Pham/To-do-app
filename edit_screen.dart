import 'package:flutter/material.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/services/dp_helper.dart';
import 'package:todo_app/model/note.dart';
class EditScreen extends StatelessWidget {
  int selected ;
   EditScreen({required this.selected,Key? key}) : super(key: key);

  final _Titlecontroller = TextEditingController();
  final _Descriptioncontroller = TextEditingController();
  late Note notes ;
  String title = '';
  String description = '';
  @override
  Widget build(BuildContext context) {
    var db = DBhelper();
    void dispose(){
      _Titlecontroller.clear();
      _Descriptioncontroller.clear();
    }
    void refresh() async{
      List<Note> note = await db.getAll();
      Note data = note[selected];
      if(selected >= 0){
        _Titlecontroller.text = data.title;
        _Descriptioncontroller.text = data.description;
      }
      notes = data;
    }


    return Scaffold(
      backgroundColor: AppColor.color1,
      appBar: AppBar(
        title: Text('Edit the Note'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50 , 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Row(
                children: [
                  Icon(Icons.insert_emoticon, size: 30,color: AppColor.color2,),
                  SizedBox(width: 10,),
                  Text('Title:', style: TextStyle(
                    color: AppColor.color2,
                    fontSize: 30, fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Line(50,'fill title', _Titlecontroller),
              SizedBox(height: 20,),
              Row(
                children: [
                  Icon(Icons.insert_emoticon, size: 30,color: AppColor.color2,),
                  SizedBox(width: 10,),
                  Text('Description:', style: TextStyle(
                    color: AppColor.color2,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Line(200, 'Description sth', _Descriptioncontroller),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 60,
                    width: 120,
                    child: InkWell(
                      onTap: (){
                      },

                      onDoubleTap: (){
                        title = _Titlecontroller.text.trim();
                        description = _Descriptioncontroller.text.trim();
                        notes.title = title;
                        notes.description = description;
                        db.Update(notes);
                        Navigator.pop(context);
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent
                        ),
                          onPressed: (){
                            title = _Titlecontroller.text.trim();
                            description = _Descriptioncontroller.text.trim();
                            Note note = Note( title: title, description: description, status: false);
                            db.AddNote(note);
                            Navigator.pop(context);
                          },
                          child: Text(
                        'submit',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      )),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    refresh();
                  }, child: Text('Refresh')),
                  SizedBox(
                    height: 60,
                    width: 120,
                    child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.Red
                        ),
                        onPressed: (){
                          dispose();

                        },
                        child: Text(
                          'clear',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget Line(double size, String hint, TextEditingController controllers){
    return Container(
      height: size ,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColor.White,
          border: Border()
      ),
      child: TextField(
        controller: controllers,
        style: TextStyle(
            color: Colors.black,
          fontSize: 20
        ),
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Colors.grey
            )
        ),
      ),
    );
  }
}


