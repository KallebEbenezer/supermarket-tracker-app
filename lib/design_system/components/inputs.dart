import 'package:flutter/material.dart' as material;

import '../tokens/app_icons.dart';

class AppTextField extends material.StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  });

  final material.TextEditingController? controller;
  final String? label;
  final String? hint;
  final void Function(String)? onChanged;
  final material.TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final String? errorText;
  final material.Widget? prefixIcon;
  final material.Widget? suffixIcon;
  final int maxLines;

  @override
  material.Widget build(material.BuildContext context) => material.TextField(
    controller: controller,
    onChanged: onChanged,
    keyboardType: keyboardType,
    obscureText: obscureText,
    enabled: enabled,
    maxLines: maxLines,
    decoration: material.InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ),
  );
}

class SearchBar extends material.StatelessWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.hintText = 'Buscar',
    this.onChanged,
    this.onClear,
  });

  final material.TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;
  final void Function()? onClear;

  @override
  material.Widget build(material.BuildContext context) => AppTextField(
    controller: controller,
    hint: hintText,
    onChanged: onChanged,
    prefixIcon: const material.Icon(AppIcons.search),
    suffixIcon: onClear == null
        ? null
        : material.IconButton(
            icon: const material.Icon(AppIcons.close),
            onPressed: onClear,
          ),
  );
}

class Dropdown<T> extends material.StatelessWidget {
  const Dropdown({
    super.key,
    required this.items,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
  });

  final List<material.DropdownMenuItem<T>> items;
  final T? value;
  final String? label;
  final String? hint;
  final void Function(T?)? onChanged;

  @override
  material.Widget build(material.BuildContext context) =>
      material.DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        decoration: material.InputDecoration(labelText: label, hintText: hint),
      );
}

class Checkbox extends material.StatelessWidget {
  const Checkbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final void Function(bool?)? onChanged;
  final String label;

  @override
  material.Widget build(material.BuildContext context) =>
      material.CheckboxListTile(
        // ignore: deprecated_member_use
        value: value,
        onChanged: onChanged,
        title: material.Text(label),
        contentPadding: material.EdgeInsets.zero,
      );
}

class RadioButton<T> extends material.StatelessWidget {
  const RadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String label;

  @override
  material.Widget build(material.BuildContext context) =>
      material.RadioListTile<T>(
        value: value,
        // ignore: deprecated_member_use
        groupValue: groupValue,
        // ignore: deprecated_member_use
        onChanged: onChanged,
        title: material.Text(label),
        contentPadding: material.EdgeInsets.zero,
      );
}

class Switch extends material.StatelessWidget {
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final void Function(bool)? onChanged;
  final String label;

  @override
  material.Widget build(material.BuildContext context) =>
      material.SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: material.Text(label),
        contentPadding: material.EdgeInsets.zero,
      );
}
