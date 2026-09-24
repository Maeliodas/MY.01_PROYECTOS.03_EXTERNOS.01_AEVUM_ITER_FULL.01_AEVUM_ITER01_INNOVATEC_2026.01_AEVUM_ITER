import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

import '../../../../core/widgets/app_notice_dialog.dart';

Widget _privacyContent(BuildContext context) {
  final muted = Theme.of(context).colorScheme.onSurfaceVariant;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        '${AppConstants.appName} · Aviso de privacidad integral',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 10),
      Text(
        '${AppConstants.appName} es una aplicación de orientación vocacional. Este aviso describe qué datos personales se recaban, para qué fines y cómo puedes ejercer tus derechos, conforme a la Ley Federal de Protección de Datos Personales en Posesión de los Particulares y demás normativa aplicable.',
        style: TextStyle(color: muted),
      ),
      const SizedBox(height: 16),
      const _Section(
        '1. Responsable del tratamiento',
        'La instancia responsable es la institución que opera esta instalación de ${AppConstants.appName} ([Nombre de la institución responsable]). Para dudas sobre este aviso puedes escribir a [correo de contacto de privacidad].',
      ),
      const _Section(
        '2. Datos personales que se recaban',
        'Nombre, edad, género, estado, municipio, escuela de procedencia, lenguas o idiomas seleccionados, fotografía o imagen de avatar, respuestas del test vocacional, resultado RIASEC con código Holland, carrera recomendada y respuestas complementarias a la pregunta abierta.',
      ),
      const _Section(
        '3. Datos sensibles',
        'No se solicitan datos sensibles (origen étnico o racial, estado de salud, creencias, preferencias u otros). No proporciones ese tipo de información en tus respuestas.',
      ),
      const _Section(
        '4. Finalidades primarias',
        'Crear tu perfil de estudiante, aplicar el test vocacional, calcular tu resultado y mostrarte carreras afines, conservar tu historial dentro de la app y sincronizar tus evaluaciones con el servidor institucional.',
      ),
      const _Section(
        '5. Finalidades secundarias',
        'Generar estadísticas académicas agregadas (sin identificarte) para mejorar la oferta de orientación. Si no estás de acuerdo con estas finalidades, puedes manifestarlo por los medios de contacto indicados.',
      ),
      const _Section(
        '6. Consentimiento',
        'Al completar tu perfil y responder el test otorgas tu consentimiento para el tratamiento descrito. Tratándose de menores de edad, el consentimiento corresponde a quien ejerza la patria potestad o tutela.',
      ),
      const _Section(
        '7. Transferencias',
        'Tus evaluaciones se transmiten únicamente al servidor institucional configurado para esta instalación. No se transfieren datos a terceros con fines distintos a los descritos sin tu consentimiento, salvo los casos previstos por la ley.',
      ),
      const _Section(
        '8. Almacenamiento local y sincronización',
        'La app conserva una copia local en tu dispositivo para funcionar sin conexión. Cuando el servidor institucional está configurado y disponible, las evaluaciones pendientes y los catálogos se sincronizan mediante la API de ${AppConstants.appName}.',
      ),
      const _Section(
        '9. Seguridad',
        'La comunicación con el servidor debe realizarse mediante HTTPS/TLS en producción, el acceso administrativo al panel debe mantenerse protegido con credenciales y las claves de ingesta no deben exponerse en clientes públicos.',
      ),
      const _Section(
        '10. Conservación y bloqueo',
        'Los datos se conservan durante el tiempo necesario para las finalidades descritas y los plazos legales aplicables; posteriormente se bloquean y, en su caso, se suprimen. Los registros históricos anonimizados pueden conservarse con fines estadísticos.',
      ),
      const _Section(
        '11. Derechos ARCO',
        'Tienes derecho a acceder, rectificar y cancelar tus datos, oponerte a su tratamiento y revocar tu consentimiento. Presenta tu solicitud por los medios de contacto de este aviso, indicando tu nombre, el derecho que deseas ejercer y los datos involucrados; recibirás respuesta en los plazos de ley.',
      ),
      const _Section(
        '12. Menores de edad',
        'Esta app está dirigida a estudiantes, incluidos menores de edad. Se recomienda la supervisión de madres, padres o tutores durante su uso.',
      ),
      const _Section(
        '13. Cambios a este aviso',
        'Cualquier cambio se comunicará a través de la propia app o del panel institucional antes de su entrada en vigor.',
      ),
      const SizedBox(height: 4),
      Text(
        'Última actualización de este texto: versión AIPROD2.3.0_R3_IN de ${AppConstants.appName}. No sustituye el aviso de privacidad integral que corresponda a cada instalación.',
        style: TextStyle(fontSize: 12, color: muted),
      ),
    ],
  );
}

Future<void> showPrivacyNoticeDialog(BuildContext context) {
  return showAppNoticeDialog(
    context,
    icon: Icons.privacy_tip_outlined,
    title: 'Aviso de privacidad',
    content: _privacyContent(context),
    buttonText: 'Cerrar',
  );
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Aviso de privacidad')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
          children: [_privacyContent(context)],
        ),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section(this.title, this.body);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(body),
          ],
        ),
      );
}
