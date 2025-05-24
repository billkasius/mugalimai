import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../../../core/models/subject_model.dart';

class SubjectSelector extends StatelessWidget {
  final List<SubjectModel> subjects;
  final SubjectModel? selectedSubject;
  final Function(String) onSubjectChanged;

  const SubjectSelector({
    super.key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          FadeInLeft(
            child: Icon(
              Icons.subject,
              color: selectedSubject?.color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: selectedSubject?.color.withOpacity(0.1) ??
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedSubject?.color.withOpacity(0.3) ??
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSubject?.id,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: selectedSubject?.color ?? Theme.of(context).colorScheme.primary,
                    ),
                    style: TextStyle(
                      color: selectedSubject?.color ?? Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    items: subjects.map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject.id,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: subject.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              subject.name,
                              style: TextStyle(
                                color: subject.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onSubjectChanged(value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
