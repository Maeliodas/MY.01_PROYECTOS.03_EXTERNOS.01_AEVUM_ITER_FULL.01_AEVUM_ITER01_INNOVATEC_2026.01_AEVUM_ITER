
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/local_image.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../avatar/presentation/providers/avatar_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});
  @override ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _nameController = TextEditingController(text: profile?.name ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = ref.read(profileProvider);
      if (p == null) return;
      if (p.avatarConfig.avatarPath.startsWith('/') || p.avatarConfig.avatarPath.contains('emulated')) {
        ref.read(avatarProvider.notifier).selectCustomPhoto(p.avatarConfig.avatarPath);
      } else {
        ref.read(avatarProvider.notifier).selectAvatar(p.avatarConfig.avatarPath);
      }
    });
  }

  @override void dispose() { _nameController.dispose(); super.dispose(); }

  Future<void> _pickGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 88);
    if (picked != null) ref.read(avatarProvider.notifier).selectCustomPhoto(picked.path);
  }

  Widget _avatarImage(String path, {double fallbackSize = 54}) {
    final local = isLocalPhoto(path);
    return local
        ? localImage(path, iconSize: fallbackSize)
        : Image.asset(path, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.person, size: fallbackSize));
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(profileProvider);
    final avatar = ref.watch(avatarProvider);
    if (current == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(14, 10, 14, 28 + MediaQuery.viewPaddingOf(context).bottom),
          children: [
            _AvatarHero(image: _avatarImage(avatar.avatarPath), onEdit: _pickGallery),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Selecciona tu avatar',
              icon: Icons.face_retouching_natural_rounded,
              child: Column(children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 13,
                  runSpacing: 14,
                  children: defaultAvatars.map((path) {
                    final active = avatar.avatarPath == path;
                    return InkWell(
                      onTap: () => ref.read(avatarProvider.notifier).selectAvatar(path),
                      borderRadius: BorderRadius.circular(50),
                      child: Stack(clipBehavior: Clip.none, children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 68, height: 68, padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.outlineVariant,
                              width: active ? 3 : 1.5,
                            ),
                          ),
                          child: ClipOval(child: _avatarImage(path, fallbackSize: 34)),
                        ),
                        if (active) Positioned(right: -3, bottom: -2, child: Container(width: 24, height: 24, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, color: Colors.white, size: 17))),
                      ]),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(onPressed: _pickGallery, icon: const Icon(Icons.photo_library_outlined), label: const Text('Elegir una foto de la galería')),
              ]),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Información personal',
              icon: Icons.badge_outlined,
              child: Column(children: [
                TextFormField(controller: _nameController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person_outline_rounded))),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _ReadOnlyField(label: 'Edad', value: '${current.age}', icon: Icons.cake_outlined)),
                  const SizedBox(width: 12),
                  Expanded(child: _ReadOnlyField(label: 'Género', value: current.gender, icon: Icons.person_search_outlined)),
                ]),
              ]),
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              text: 'Guardar cambios', icon: Icons.save_rounded,
              onPressed: () async {
                final updated = UserProfile(
                  id: current.id, name: _nameController.text.trim().isEmpty ? current.name : _nameController.text.trim(),
                  age: current.age, gender: current.gender,
                  stateId: current.stateId, state: current.state,
                  municipalityId: current.municipalityId, municipality: current.municipality,
                  schoolId: current.schoolId, school: current.school,
                  speaksLanguages: current.speaksLanguages, languageIds: current.languageIds, languagesList: current.languagesList,
                  avatarConfig: ref.read(avatarProvider), createdAt: current.createdAt,
                );
                await ref.read(profileProvider.notifier).saveProfile(updated);
                if (context.mounted) context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarHero extends StatelessWidget {
  final Widget image;
  final VoidCallback onEdit;
  const _AvatarHero({required this.image, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.outlineVariant),
        gradient: LinearGradient(
          colors: dark
              ? [
                  colors.surfaceContainerHighest,
                  AppColors.primary.withValues(alpha: .16),
                ]
              : const [
                  Color(0xFFDFE9FF),
                  Color(0xFFDDF2F8),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 145,
              height: 145,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 4),
                ),
                child: ClipOval(child: image),
              ),
            ),
            Positioned(
              right: -4,
              bottom: 7,
              child: Material(
                color: const Color(0xFF42A5E3),
                shape: const CircleBorder(),
                elevation: 3,
                child: InkWell(
                  onTap: onEdit,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label, value; final IconData icon;
  const _ReadOnlyField({required this.label, required this.value, required this.icon});
  @override Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
  );
}
