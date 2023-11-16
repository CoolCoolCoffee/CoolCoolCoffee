class Star{
  bool isStared;
  Star({required this.isStared});
  void clicked(){
    isStared = !isStared;
  }
}