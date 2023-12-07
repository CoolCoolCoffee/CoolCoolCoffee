class AlarmPermission{
  //허락 받았냐?
  bool isPermissioned;
  //오늘 보냈냐?
  bool isToday;
  AlarmPermission({required this.isToday, required this.isPermissioned});
}