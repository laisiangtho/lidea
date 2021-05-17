library lidea;

extension LideaStringExtension on String {
  String bracketsHack() {
    return this.replaceAllMapped(RegExp(r'\[(.*?)\]'), (Match i) => i.group(1).toString().split('').reversed.join());
  }
  String gitHack() {
    return this.replaceFirst('git+http', 'http').replaceFirst('git+', '[moc.buhtig//:sptth]').bracketsHack();
  }
}