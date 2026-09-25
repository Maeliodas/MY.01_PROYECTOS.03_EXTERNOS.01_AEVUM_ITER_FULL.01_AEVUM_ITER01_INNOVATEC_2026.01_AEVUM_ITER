import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/avatar_provider.dart';

class CustomAvatarPage extends ConsumerWidget {
  final bool returnToProfile;
  final bool returnToPersonalData;
  const CustomAvatarPage({super.key, this.returnToProfile = false, this.returnToPersonalData = false});

  Future<void> _pickGallery(WidgetRef ref) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 88);
    if (picked != null) ref.read(avatarProvider.notifier).selectCustomPhoto(picked.path);
  }

  Future<void> _pickCamera(WidgetRef ref) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 88);
    if (picked != null) ref.read(avatarProvider.notifier).selectCustomPhoto(picked.path);
  }

  Future<void> _finish(BuildContext context, WidgetRef ref) async {
    if (returnToPersonalData) {
      // Vuelve a la pantalla de datos existente (conserva lo ya escrito).
      // Si se llegó vía elegir-avatar, un pop cae ahí y el Continuar de esa
      // pantalla hace el segundo pop.
      if (context.canPop()) {
        context.pop();
        return;
      }
      context.push('/personal-data');
      return;
    }
    if (!returnToProfile) {
      context.push('/personal-data');
      return;
    }
    final current = ref.read(profileProvider);
    if (current != null) {
      final updated = UserProfile(
        id: current.id,
        name: current.name,
        age: current.age,
        gender: current.gender,
        stateId: current.stateId,
        state: current.state,
        municipalityId: current.municipalityId,
        municipality: current.municipality,
        schoolId: current.schoolId,
        pendingSchoolSuggestionId: current.pendingSchoolSuggestionId,
        school: current.school,
        pendingSchoolName: current.pendingSchoolName,
        speaksLanguages: current.speaksLanguages,
        languageIds: current.languageIds,
        languagesList: current.languagesList,
        avatarConfig: ref.read(avatarProvider),
        createdAt: current.createdAt,
      );
      await ref.read(profileProvider.notifier).saveProfile(updated);
    }
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(avatarProvider);
    final isCustom = selected.baseAvatarId == 'custom_photo';
    final Widget preview = isCustom
        ? ClipOval(child: Image.file(File(selected.avatarPath), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 90)))
        : ClipOval(child: Image.asset(selected.avatarPath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 90)));

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: Theme.of(context).brightness == Brightness.dark ? const [Color(0xFF0A1428), Color(0xFF10203A), Color(0xFF0C1A33)] : const [Color(0xFFF3F8FF), Color(0xFFF7FAFF), Color(0xFFE9F1FF)])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
            child: Column(children: [
              const Row(children: [AppBackButton()]),
              const SizedBox(height: 10),
              const Text('Tu foto', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Elige una imagen de tu galería o toma una foto en este momento.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.35, color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              Container(width: 210, height: 210, padding: const EdgeInsets.all(6), decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.surface, border: Border.all(color: AppColors.primary, width: 4)), child: preview),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(child: SecondaryButton(text: 'Galería', onPressed: () => _pickGallery(ref))),
                const SizedBox(width: 10),
                Expanded(child: SecondaryButton(text: 'Tomar foto', onPressed: () => _pickCamera(ref))),
              ]),
              const Spacer(),
              PrimaryButton(text: returnToProfile ? 'Guardar avatar' : 'Continuar', icon: Icons.arrow_forward_rounded, onPressed: () => _finish(context, ref)),
            ]),
          ),
        ),
      ),
    );
  }
}
