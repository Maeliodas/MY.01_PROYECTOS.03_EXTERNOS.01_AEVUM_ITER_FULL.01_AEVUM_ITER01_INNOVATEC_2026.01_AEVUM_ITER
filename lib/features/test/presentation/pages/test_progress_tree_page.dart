import '../../../../core/widgets/local_image.dart';
import '../../../../core/constants/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/test_provider.dart';

class TestProgressTreePage extends ConsumerWidget {
  final VoidCallback? onShowResult;

  const TestProgressTreePage({super.key, this.onShowResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final test = ref.watch(testProvider);
    final profile = ref.watch(profileProvider);
    if (!test.restored || test.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
    }
    final complete = test.isCompleted;
    final answered = test.answers.length;
    final totalQuestions = test.questions.length;
    final percentage = complete
        ? 100
        : totalQuestions == 0 ? 0 : ((answered / totalQuestions) * 100).round().clamp(0, 100);

    void continueTest() => context.push('/test');
    void showResult() {
      if (onShowResult != null) {
        onShowResult!();
      } else {
        context.go('/path-home?tab=1');
      }
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? const [Color(0xFF0A1428), Color(0xFF0D1830), Color(0xFF0B1730)]
                : const [Color(0xFFF2F7FF), Color(0xFFF1F5FF), Color(0xFFEAF3FF)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
            children: [
              Row(
                children: [
                  _Avatar(path: profile?.avatarConfig.avatarPath),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      profile == null
                          ? '¡Hola!'
                          : '¡Hola, ${profile.name.split(' ').first}!',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0262FC),
                      ),
                    ),
                  ),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0262FC),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .07),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'PROGRESO ACTUAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF18A9D3),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Icon(Icons.rocket_launch_rounded, color: Color(0xFF18A9D3), size: 30),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      complete
                          ? 'Tu viaje profesional\nestá despegando.'
                          : answered == 0
                              ? 'Tu viaje aún no\ncomienza.'
                              : 'Tu viaje profesional\nsigue avanzando.',
                      style: const TextStyle(
                        fontSize: 25,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 9,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF17A9D4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (answered == 0 && !complete) ...[
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8FBEFF),
                        Color(0xFF0262FC),
                        Color(0xFF8FD8F8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: InkResponse(
                      onTap: continueTest,
                      radius: 60,
                      child: const CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.map_rounded,
                          size: 48,
                          color: Color(0xFF6C2BD0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Tu viaje aún no\ncomienza.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Descubre tu potencial hoy mismo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .68),
                  ),
                ),
                const SizedBox(height: 28),
                _ActionButton(text: 'Iniciar Test', onTap: continueTest, icon: Icons.play_arrow_rounded),
              ] else ...[
                _Node(
                  icon: Icons.favorite_rounded,
                  title: 'Intereses',
                  done: answered >= ((totalQuestions / 3).ceil()) || complete,
                  active: !complete && answered < ((totalQuestions / 3).ceil()),
                  onTap: complete ? showResult : continueTest,
                ),
                const _Connector(),
                _Node(
                  icon: Icons.psychology_rounded,
                  title: 'Habilidades',
                  done: answered >= ((totalQuestions * 2 / 3).ceil()) || complete,
                  active: !complete && answered >= ((totalQuestions / 3).ceil()) && answered < ((totalQuestions * 2 / 3).ceil()),
                  onTap: answered >= ((totalQuestions / 3).ceil())
                      ? (complete ? showResult : continueTest)
                      : null,
                ),
                const _Connector(),
                _Node(
                  icon: Icons.person_search_rounded,
                  title: 'Personalidad',
                  done: complete,
                  active: !complete && answered >= ((totalQuestions * 2 / 3).ceil()),
                  onTap: answered >= ((totalQuestions * 2 / 3).ceil())
                      ? (complete ? showResult : continueTest)
                      : null,
                ),
                const _Connector(),
                _Node(
                  icon: Icons.workspace_premium_rounded,
                  title: 'Resultado',
                  done: complete,
                  active: false,
                  onTap: complete ? showResult : null,
                ),
                const SizedBox(height: 26),
                _ActionButton(
                  text: complete ? 'Ver resultado  →' : 'Continuar Test  →',
                  onTap: complete ? showResult : continueTest,
                ),
                const SizedBox(height: 10),
                if (complete)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(testProvider.notifier).resetTest();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reiniciar Test'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? path;

  const _Avatar({this.path});

  @override
  Widget build(BuildContext context) {
    Widget child = const Icon(Icons.person, size: 24);
    if (path != null && path!.isNotEmpty) {
      child = isLocalPhoto(path!)
          ? localImage(path!, iconSize: 24)
          : Image.asset(
              path!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.person),
            );
    }

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: ClipOval(child: child),
    );
  }
}

class _Node extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool done;
  final bool active;
  final VoidCallback? onTap;

  const _Node({
    required this.icon,
    required this.title,
    required this.done,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final secondary = Theme.of(context).colorScheme.onSurface.withValues(alpha: .58);
    final circleColor = done || active
        ? AppColors.primary
        : (dark ? const Color(0xFF232F45) : const Color(0xFFDCE4F0));

    return Semantics(
      button: enabled,
      label: enabled ? '$title. Toca para continuar.' : title,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: active ? 82 : 74,
                height: active ? 82 : 74,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: active
                      ? Border.all(color: Colors.white, width: 5)
                      : null,
                  boxShadow: done || active
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .27),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  done ? Icons.check_rounded : icon,
                  color: done || active ? Colors.white : secondary,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          Text(
            done
                ? 'COMPLETADO'
                : active
                    ? 'CONTINUAR'
                    : 'PENDIENTE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: done || active
                  ? AppColors.primary
                  : secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 6,
        height: 48,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const _ActionButton({required this.text, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: const Color(0xFFFFFFFF),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 9)],
          Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }
}
