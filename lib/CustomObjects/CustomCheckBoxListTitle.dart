import 'package:flutter/material.dart';

class CustomCheckBoxListTitle extends CheckboxListTile {
  CustomCheckBoxListTitle({
    Key? key,
    @required value,
    @required onChanged,
    contentPadding,
    controlAffinity,
    title,
  }) : super(
          key: key,
          value: value,
          onChanged: onChanged,
          contentPadding: contentPadding,
          controlAffinity: controlAffinity,
          title: title,
        );

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget control = SizedBox(
      height: 40,
      width: 40,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: checkColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        autofocus: autofocus,
        tristate: tristate,
      ),
    );
    Widget? leading, trailing;
    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = secondary;
        break;
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        leading = secondary;
        trailing = control;
        break;
    }
    return MergeSemantics(
      child: ListTileTheme.merge(
        selectedColor: activeColor ?? Theme.of(context).accentColor,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          isThreeLine: isThreeLine,
          dense: dense,
          enabled: onChanged != null,
          onTap: onChanged != null ? _handleValueChange : null,
          selected: selected,
          autofocus: autofocus,
          contentPadding: contentPadding,
          shape: shape,
          selectedTileColor: selectedTileColor,
          tileColor: tileColor,
        ),
      ),
    );
  }
}
