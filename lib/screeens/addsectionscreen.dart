
import 'package:attendence_system/apiservices/addsectionservices.dart';

import 'package:attendence_system/models/section.dart';
import 'package:flutter/material.dart';

class AddSectionScreen extends StatefulWidget {
  const AddSectionScreen({super.key});

  @override
  State<AddSectionScreen> createState() => _AddSectionScreenState();
}

class _AddSectionScreenState extends State<AddSectionScreen> {

  final _formKey = GlobalKey<FormState>();
  final SectionController = TextEditingController();

  bool isLoading = false;

  void addCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final section = SectionModel(sectionName: SectionController.text);

  try{
       var response=await AddSectionServices().registerSection(section);
       if(response.statusCode==200){
       ScaffoldMessenger.of(context).showSnackBar(  const SnackBar(content: Text('Section Added Successfully')),);
       }
  }catch(e){
 ScaffoldMessenger.of(context).showSnackBar(  const SnackBar(content: Text('Something Wrong ')),);
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Section'),
      backgroundColor: Colors.blue.shade100),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: SectionController,
                decoration: const InputDecoration(
                  labelText: 'Section Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter Section name' : null,
              ),
             
              
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: isLoading ? null : addCourse,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Section'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
