import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../view/widgets/toast_view/showtoast.dart';

class FileResource {
  static FileResource? _instance;
  static FileResource get instance => _instance ??= FileResource._init();
  FileResource._init();

  Future<XFile> imagePickerFromGallery() async {
    XFile pickedFile = XFile("");
    try{
      await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 30).then((value) {
        pickedFile = value ?? XFile("");
      });
      return pickedFile;
    }catch(e){
      return XFile("");
    }
  }

  Future<XFile> imagePickerFromCamara() async {
    XFile pickedFile = XFile("");
    try{
      await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 30).then((value) {
        pickedFile = value ?? XFile("");
      });
      return pickedFile;
    }catch(e){
      return XFile("");
    }
  }

  Future<List<SelectedMediaModel>> getFileFromDevice({required bool allowMultiple, required List<String> allowedExtensions,required int fileSize})async{
    List<SelectedMediaModel> files = <SelectedMediaModel>[];
    try{
      (allowedExtensions).logPrint();
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: allowMultiple , allowedExtensions:allowedExtensions,allowCompression: true);
      for (var element in result?.files ??[]) {
        (result)?.logPrint();
        (p.extension(element.path)).logPrint();
        if(getFileSize(File(element.path??"")) < fileSize){
          files.add(SelectedMediaModel(files: XFile(element.path!), video: false));
        }else{
          toastShow(message: "${"You must keep the file size under".tr} ${fileSize}MB.",error: true);
        }
      }
    } on PlatformException catch (e) {
      toastShow(message: "Permission required to access files.", error: true);
    } catch (e) {
      toastShow(message: e.toString(),error: true);
    }
    return  files;
  }


  double getFileSize(File filepath){
    int sizeInBytes = filepath.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

}

class SelectedMediaModel {
  XFile files;
  Uint8List? uint8list;
  bool? video;
  SelectedMediaModel({required this.files,this.video,this.uint8list});
}