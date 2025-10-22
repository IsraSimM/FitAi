import "package:flutter/widgets.dart";

/// Breakpoints simples para layout responsivo.
bool isPhone(BuildContext context) => MediaQuery.sizeOf(context).width < 600;
bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 600 &&
    MediaQuery.sizeOf(context).width < 1024;
bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 1024;
