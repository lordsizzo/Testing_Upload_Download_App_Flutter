import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import 'package:testing_upload_download_app/service.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: CustomFilePicker() //set the class here
    );
  }
}

class CustomFilePicker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CustomFilePicker();
  }
}

class _CustomFilePicker extends State<CustomFilePicker>{

  File selectedfile = File("");
  String progress = "";
  String responseResult = "";
  double valueProgress  = 0;

  selectFile() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedfile = File(image!.path);
    });
  }

  uploadFile() async {
    FileService().fileUploadMultipart("cool_image", selectedfile, _setUploadProgress).whenComplete(() {})
        .then((response) async {
        if(response.statusCode == 200){
          print("$response");
        }else{
          print("Error during connection to server.");
        }
      setState(() {});
    });

  }

  void _setUploadProgress(int sent, int total) {
    String percentage = (sent/total*100).toStringAsFixed(2);
    setState(() {
      progress = "$sent" + " Bytes of " "$total Bytes";
      valueProgress = double.parse(percentage)/100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("Select File and Upload"),
          backgroundColor: Colors.orangeAccent,
        ), //set appbar
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(40),
              child:Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  //show file name here
                  child:progress == null?
                  Text("Progress: 0%"):
                  Text(basename("Progress: $progress"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),),
                  //show progress status here
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                        color: Colors.red,
                        minHeight: 5,
                        value: valueProgress,
                      ),
                      Text("Progress: ${(valueProgress*100).toStringAsFixed(2)} %"),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child:Text(responseResult),
                ),

                Container(
                  margin: EdgeInsets.all(10),
                  //show file name here
                  child:selectedfile == null?
                  Text("Choose File"):
                  Text(basename(selectedfile.path)),
                ),
                selectedfile != null? Image.file(
                  selectedfile!,
                  fit: BoxFit.cover,
                ): Container(),

                Container(
                  margin: EdgeInsets.all(10),
                  child:FloatingActionButton(
                    elevation: 3,
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      selectFile();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.file_copy),
                    ),
                  ),
                ),

                selectedfile == null?
                Container():
                Container(
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton(
                    elevation: 3,
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      uploadFile();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.send),
                    ),
                  ),
                )

              ],)
          ),
        )
    );
  }
}