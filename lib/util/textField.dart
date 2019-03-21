class TextFieldUtil {
  static String validator(String hint, String text, String purpose) {
    var baseCondition = [hint, ""].contains(text);
    var invalidMessage = "$hint ungültig";

    if (purpose == "email") {
      if (baseCondition || !text.contains("@")) return invalidMessage;
    } else if (baseCondition) {
      return invalidMessage;
    }

    return null;
  }
}