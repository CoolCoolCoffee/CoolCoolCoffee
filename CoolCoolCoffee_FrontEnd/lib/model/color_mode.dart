class ColorMode{
  //조절모드일 때 isControlMode= true, selextedIndex = 0
  //밤샘모드일 때 isControlMode = false, selextedIndex = 1
  bool isControlMode;
  int selectedIndex;
  ColorMode({required this.isControlMode,required this.selectedIndex});
}