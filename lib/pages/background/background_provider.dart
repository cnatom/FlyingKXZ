import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flying_kxz/Model/prefs.dart';
import 'package:flying_kxz/ui/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// 设置背景

class BackgroundProvider extends ChangeNotifier {
  // static String _backgroundImagePrefsStr = "background_image2";
  static String _backgroundImagePrefsStr = "background_image3";

  static String backgroundPath;

  Directory documentDirectory;

  String get getBackgroundPath {
    if (backgroundPath == null) {
      String prefsPath = Prefs.prefs.getString(_backgroundImagePrefsStr);
      if (prefsPath != null) {
        documentDirectory = Directory("${documentDirectory.path}/background/");
        if(documentDirectory.existsSync()){
          List<FileSystemEntity> entities = documentDirectory.listSync();
          for(var entity in entities){
            if(entity.path.contains("background_image")){
              backgroundPath = entity.path;
              break;
            }
          }
        }else{
          backgroundPath = "images/background.png";
        }
      } else {
        backgroundPath = "images/background.png";
      }
    }
    return backgroundPath;
  }

  Future<void> precacheBackground(BuildContext context)async{
    if (getBackgroundPath != "images/background.png") {
      if (await File(getBackgroundPath).exists()) {
        await precacheImage(new FileImage(File(getBackgroundPath)), context);
      }
    } else {
      await precacheImage(new AssetImage("images/background.png"), context);
    }
  }

  init() async {
    documentDirectory = (await getApplicationDocumentsDirectory());
  }

  BackgroundProvider() {
    init();
  }

  void setBackgroundImage() async {
    try{
      XFile pickedImage = await _pickImage();
      if (pickedImage != null) {
        String imagePath = await _copyImageToStorage(pickedImage.path);
        backgroundPath = imagePath;
        Prefs.prefs.setString(_backgroundImagePrefsStr, imagePath);
        showToast("🎉更换成功！");
        notifyListeners();
      }
    }catch(e){
      showToast("😭更换失败～\n${e.toString()}");
    }
  }

  Future<void> _createFolderIfNotExists(String folderPath) async {
    Directory folder = Directory(folderPath);
    bool folderExists = await folder.exists();
    if (!folderExists) {
      await folder.create(recursive: true);
    }
  }

  Future<String> _copyImageToStorage(String imagePath) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String directoryPath = '${appDocumentsDirectory.path}/background';
    await _createFolderIfNotExists(directoryPath);
    await _deleteFolderContents(directoryPath);
    String fileExtension = imagePath.split('.').last; // 获取原始文件的扩展名
    String newImagePath =
        '$directoryPath/background_image${DateTime.now().toString()}.$fileExtension'; // 使用统一的文件名和原始扩展名
    // 删除上一个背景图片
    File previousImageFile = File(newImagePath);
    if (await previousImageFile.exists()) {
      await previousImageFile.delete();
    }
    // 复制新的图片到文档目录
    File imageFile = File(imagePath);
    await imageFile.copy(newImagePath);
    return newImagePath;
  }

  Future<void> _deleteFolderContents(String folderPath) async {
    Directory folder = Directory(folderPath);
    if (await folder.exists()) {
      List<FileSystemEntity> contents = folder.listSync();
      for (FileSystemEntity file in contents) {
        if (file is File) {
          await file.delete();
        } else if (file is Directory) {
          await _deleteFolderContents(file.path);
          await file.delete();
        }
      }
    }
  }

  Future<XFile> _pickImage() async {
    final imagePicker = ImagePicker();
    try {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      return pickedImage;
    } catch (e) {
      showToast("不支持该图片格式\n${e.toString()}");
      return null;
    }
  }
}
