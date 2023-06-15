

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/colors/color.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/screens/edit_screen.dart';
import 'package:todo_app/services/dp_helper.dart';
class HomeScreen extends StatefulWidget  {
  const HomeScreen({Key? key}) : super(key: key);
  HomeScreen.ensureInitialized();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   var db  = DBhelper() ;
  Color color = AppColor.LimeGreen;
  late Color button_color ;

  List<Note> Notes = [];

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
   fetch();
  }
  void fetch() async{

    final list =await db.getAll();
    setState(() {
      Notes =  list;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.color1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.color1,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body:
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(
              children: [
                Icon(Icons.book,
                color: Colors.white),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Directory",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),),
                ),],
            ),
                SizedBox(height: 40,),

                Text('Works:',style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color:Colors.orange
                ),),
                SizedBox(height:10 ,),

                Expanded(

                  child: ListView.builder(
                    itemCount: Notes.length,
                      itemBuilder: (context, index){

                      return Item(index);
                  }),
                )
          ]),
        ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context)=> EditScreen(selected: -1,)));
         fetch();
      },
      child: Icon(Icons.add_comment),
      elevation: 10 ,
      backgroundColor: AppColor.color2,

    ),
    );
  }
  Widget Item(int index){
    final data = Notes[index];

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10)
        ),
        child: ListTile(
          onTap: (){
            data.status = data.status == true ? false:true;
            db.Update(data);
            print(data.status);
            print(Notes.length);
            setState(() {

              color = data.status == false ? AppColor.DarkGreen: AppColor.LimeGreen;

            });
          },
          leading: Checkbox(
            value: data.status,
            onChanged: (value){
              setState(() {
                data.status = data.status == true ? false:true;
                db.Update(data);
                color = data.status == false ? AppColor.DarkGreen: AppColor.LimeGreen;
              });
            },
          ) ,
          title: Text(data.title),
          subtitle: Text(data.description),
          trailing: SizedBox(
            width: 60,
            child: Row(
              children: [
                InkWell(
                  onTap: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=> EditScreen(selected: index,)));
                    fetch();
                  },
                  child: Icon(Icons.edit),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    showDialog(context: context, builder:(context) => AlertDialog(
                      title: Text('Do you really want Delete this Note'),
                      content: Text('Yes or No'),
                      actions: [
                        IconButton(onPressed: (){
                          db.Delete(data);
                          Navigator.pop(context);
                          setState(() {
                            fetch();
                          });
                        }, icon: Icon(Icons.check),),

                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text('X')),
                      ],
                    )

                    );
                  },
                  child: Icon(Icons.delete),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
