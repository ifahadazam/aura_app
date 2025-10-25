extension FindPercentage on num {
  int percentage({required int total}) {
    final learnedPercent = (toInt() / total) * 100;
    final roundedPercent = learnedPercent.round();
    return roundedPercent;
  }
}
