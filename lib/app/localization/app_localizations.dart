import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Lightweight app-specific localization helper.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const delegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'greeting': 'Hi,',
      'notifications': 'Notifications',
      'settings': 'Settings',
      'social_active_rankings': 'Active rankings',
      'social_leaderboard_streak': 'Streaks',
      'social_leaderboard_weight': 'Weight',
      'social_leaderboard_cardio': 'Cardio',
      'social_leaderboard_community': 'Community',
      'social_load_error': 'We could not load the rankings',
      'common_retry': 'Retry',
      'social_invite_friends': 'Invite friends',
      'social_score_label': 'Score',
      'social_score_change': 'Change',
      'settings_theme_tab': 'Theme',
      'settings_language_tab': 'Language',
      'settings_notifications_tab': 'Notifications',
      'settings_theme_mode_title': 'Theme mode',
      'settings_color_section': 'Custom colors',
      'settings_primary_color': 'Primary',
      'settings_secondary_color': 'Secondary',
      'settings_select_language': 'Choose language',
      'settings_select_base_color': 'Choose base color',
      'language_en': 'English',
      'language_es': 'Spanish',
      'language_pt': 'Portuguese',
      'notifications_push': 'Push',
      'notifications_push_subtitle': 'Receive alerts on the device',
      'notifications_email': 'Email',
      'notifications_email_subtitle': 'Weekly summary and campaigns',
      'notifications_in_app': 'In-app',
      'notifications_in_app_subtitle': 'Banners and reminders inside FreeT',
      'notifications_daily': 'Daily reminders',
      'notifications_weekly': 'Weekly summary',
      'notifications_tips': 'Personalised tips',
      'common_error_generic': 'An error occurred',
      'common_edit': 'Edit',
      'common_configure': 'Configure',
      'common_back': 'Back',
      'common_next': 'Next',
      'common_finish': 'Finish',
      'common_generate': 'Generate',
      'common_generating': 'Generating...',
      'common_refresh': 'Refresh',
      'common_frequency': 'Frequency',
      'common_last': 'Last',
      'time_minute_short': 'min',
      'time_hour_short': 'h',
      'time_day_short': 'd',
      'time_days_label': 'days',
      'profile_load_error': 'We couldn\'t load your profile',
      'profile_weight': 'Weight',
      'profile_height': 'Height',
      'profile_linked_devices': 'Linked devices',
      'profile_no_devices': 'No connected devices',
      'profile_device_type': 'Type',
      'profile_link_new_device': 'Link new device',
      'profile_logout_success': 'Signed out successfully',
      'settings_preferences': 'Preferences',
      'settings_telemetry_title': 'Telemetry & analytics',
      'settings_telemetry_subtitle': 'Configure metrics and custom dashboards',
      'support_title': 'Support',
      'support_faq': 'FAQ & Tickets',
      'support_faq_subtitle': 'Check the knowledge base or open a ticket',
      'support_logout': 'Sign out',
      'dashboard_error': 'We couldn\'t load your information. Try again.',
      'dashboard_attendance_registered': 'Attendance registered',
      'dashboard_register_attendance': 'Register attendance',
      'dashboard_streak_banner': 'Streak updated! Keep the momentum going.',
      'dashboard_summary_title': 'Daily summary',
      'dashboard_summary_progress_title': 'Daily progress',
      'dashboard_summary_progress_subtitle': 'Goal completed',
      'dashboard_summary_streak_title': 'Active streak',
      'dashboard_summary_streak_subtitle': 'No absences',
      'dashboard_summary_calories_title': 'Calories',
      'dashboard_summary_calories_subtitle': 'Today\'s estimate',
      'dashboard_summary_readiness_title': 'Readiness',
      'dashboard_summary_readiness_subtitle': 'Recovery',
      'dashboard_routine_title': 'Today\'s routine',
      'dashboard_stats_title': 'Statistics',
      'dashboard_stats_latest': 'Latest value',
      'dashboard_stats_goal': 'Goal',
      'dashboard_goals_title': 'Active goals',
      'dashboard_goal_current': 'Current',
      'dashboard_goal_target': 'Target',
      'dashboard_tips_title': 'Personalized tips',
      'notifications_sample_routine_title': 'Routine ready',
      'notifications_sample_routine_body':
          'Your leg routine for tomorrow is generated and ready to review.',
      'notifications_sample_routine_type': 'Routines',
      'notifications_sample_social_title': 'New social challenge',
      'notifications_sample_social_body':
          'Dana invited you to the community cardio challenge. Accept and earn extra XP!',
      'notifications_sample_social_type': 'Social',
      'notifications_sample_health_title': 'Hydration reminder',
      'notifications_sample_health_body':
          'You still need 600ml to reach your daily goal.',
      'notifications_sample_health_type': 'Health',
      'evaluation_phase_prefix': 'Phase',
      'evaluation_phase_calibrating': 'Calibrating',
      'evaluation_phase_ready': 'Ready',
      'evaluation_phase_recording': 'Recording',
      'evaluation_phase_reviewing': 'Review',
      'evaluation_action_start': 'Start evaluation',
      'evaluation_action_finish': 'Finish',
      'evaluation_action_reset': 'Reset',
      'evaluation_live_title': 'Live feedback',
      'evaluation_live_ready': 'Ready to start, adjust posture and lighting.',
      'evaluation_feedback_back_title': 'Neutral back',
      'evaluation_feedback_back_body':
          'Keep alignment, excellent execution.',
      'evaluation_feedback_knees_title': 'Knees',
      'evaluation_feedback_knees_body':
          'Avoid letting them collapse inward on the way down.',
      'evaluation_feedback_cadence_title': 'Cadence',
      'evaluation_feedback_cadence_body':
          'Control the tempo: 2s down and 1s up.',
      'evaluation_cue_posture': 'Posture',
      'evaluation_cue_range': 'Range',
      'evaluation_cue_speed': 'Tempo',
      'evaluation_summary_title': 'Session summary',
      'evaluation_save_history': 'Save to history',
      'onboarding_title': 'Set up your experience',
      'onboarding_language_title': 'Which language do you want to use FreeT in?',
      'onboarding_theme_title': 'Choose a visual theme',
      'onboarding_devices_title': 'Connect your devices',
      'onboarding_devices_band_title': 'Sync FreeT Band Pro',
      'onboarding_devices_band_subtitle':
          'Track heart rate and steps in real time',
      'onboarding_devices_sensor_title': 'Sync posture sensor',
      'onboarding_devices_sensor_subtitle':
          'Get advanced feedback during your routines',
      'onboarding_devices_manual': 'Configure manually',
      'onboarding_summary_title': 'All set',
      'onboarding_summary_devices': 'Connected devices',
      'onboarding_summary_devices_connected':
          'Band Pro and posture sensor',
      'onboarding_summary_devices_pending': 'Pending configuration',
      'onboarding_summary_note':
          'You can tweak these preferences anytime from More > Settings.',
      'routines_title': 'Your routines',
      'routines_generate_ai': 'Generate with AI',
      'routines_generating': 'Generating...',
      'routines_autogeneration_title': 'Routine autogeneration',
      'routines_autogeneration_subtitle':
          'Schedule new routines based on your goals',
      'routines_frequency': 'Frequency',
      'routines_last_generated': 'Last',
      'routines_load_error': 'We couldn\'t load your routines.',
      'routines_empty_title': 'No routines for this focus yet',
      'routines_empty_subtitle':
          'Generate a new routine or change the filter to explore more options.',
      'routine_focus_all': 'All',
      'routine_focus_full': 'Full body',
      'routine_focus_leg': 'Legs',
      'routine_focus_arm': 'Arms',
      'routine_focus_cardio': 'Cardio',
      'routine_focus_custom': 'Custom',
      'routine_frequency_weekly': 'Weekly',
      'routine_frequency_monthly': 'Monthly',
      'routine_frequency_custom': 'Custom',
      'routine_bodyweight': 'Bodyweight',
      'routine_recommended': 'Recommended',
      'routine_sets_label': 'sets',
      'routine_reps_label': 'reps',
    },
    'es': {
      'greeting': 'Hola,',
      'notifications': 'Notificaciones',
      'settings': 'Configuracion',
      'social_active_rankings': 'Rankings activos',
      'social_leaderboard_streak': 'Rachas',
      'social_leaderboard_weight': 'Peso',
      'social_leaderboard_cardio': 'Cardio',
      'social_leaderboard_community': 'Comunidad',
      'social_load_error': 'No pudimos cargar los rankings',
      'common_retry': 'Reintentar',
      'social_invite_friends': 'Invitar amigos',
      'social_score_label': 'Puntaje',
      'social_score_change': 'Cambio',
      'settings_theme_tab': 'Tema',
      'settings_language_tab': 'Idioma',
      'settings_notifications_tab': 'Notificaciones',
      'settings_theme_mode_title': 'Modo de tema',
      'settings_color_section': 'Colores personalizados',
      'settings_primary_color': 'Primario',
      'settings_secondary_color': 'Secundario',
      'settings_select_language': 'Selecciona idioma',
      'settings_select_base_color': 'Selecciona color base',
      'language_en': 'Ingles',
      'language_es': 'Espanol',
      'language_pt': 'Portugues',
      'notifications_push': 'Push',
      'notifications_push_subtitle': 'Recibe alertas en el dispositivo',
      'notifications_email': 'Email',
      'notifications_email_subtitle': 'Resumen semanal y campanas',
      'notifications_in_app': 'In-App',
      'notifications_in_app_subtitle':
          'Banners y recordatorios dentro de FreeT',
      'notifications_daily': 'Recordatorios diarios',
      'notifications_weekly': 'Resumen semanal',
      'notifications_tips': 'Tips personalizados',
      'common_error_generic': 'Se produjo un error',
      'common_edit': 'Editar',
      'common_configure': 'Configurar',
      'common_back': 'Atras',
      'common_next': 'Siguiente',
      'common_finish': 'Finalizar',
      'common_generate': 'Generar',
      'common_generating': 'Generando...',
      'common_refresh': 'Actualizar',
      'common_frequency': 'Frecuencia',
      'common_last': 'Ultima',
      'time_minute_short': 'min',
      'time_hour_short': 'h',
      'time_day_short': 'd',
      'time_days_label': 'dias',
      'profile_load_error': 'No pudimos cargar tu perfil',
      'profile_weight': 'Peso',
      'profile_height': 'Altura',
      'profile_linked_devices': 'Dispositivos vinculados',
      'profile_no_devices': 'Sin dispositivos conectados',
      'profile_device_type': 'Tipo',
      'profile_link_new_device': 'Vincular nuevo dispositivo',
      'profile_logout_success': 'Sesion cerrada correctamente',
      'settings_preferences': 'Preferencias',
      'settings_telemetry_title': 'Telemetria y analitica',
      'settings_telemetry_subtitle':
          'Configura metricas y paneles personalizados',
      'support_title': 'Soporte',
      'support_faq': 'FAQ y tickets',
      'support_faq_subtitle':
          'Consulta la base de conocimiento o levanta un caso',
      'support_logout': 'Cerrar sesion',
      'dashboard_error':
          'No pudimos cargar tu informacion. Intenta nuevamente.',
      'dashboard_attendance_registered': 'Asistencia registrada',
      'dashboard_register_attendance': 'Registrar asistencia',
      'dashboard_streak_banner':
          'Racha actualizada! Sigue con ese impulso.',
      'dashboard_summary_title': 'Resumen diario',
      'dashboard_summary_progress_title': 'Progreso diario',
      'dashboard_summary_progress_subtitle': 'Objetivo completado',
      'dashboard_summary_streak_title': 'Racha activa',
      'dashboard_summary_streak_subtitle': 'Sin ausencias',
      'dashboard_summary_calories_title': 'Calorias',
      'dashboard_summary_calories_subtitle': 'Estimado de hoy',
      'dashboard_summary_readiness_title': 'Preparacion',
      'dashboard_summary_readiness_subtitle': 'Recuperacion',
      'dashboard_routine_title': 'Rutina de hoy',
      'dashboard_stats_title': 'Estadisticas',
      'dashboard_stats_latest': 'Ultimo valor',
      'dashboard_stats_goal': 'Meta',
      'dashboard_goals_title': 'Metas activas',
      'dashboard_goal_current': 'Actual',
      'dashboard_goal_target': 'Meta',
      'dashboard_tips_title': 'Tips personalizados',
      'notifications_sample_routine_title': 'Rutina lista',
      'notifications_sample_routine_body':
          'Tu rutina de pierna para manana ya esta generada y lista para revisar.',
      'notifications_sample_routine_type': 'Rutinas',
      'notifications_sample_social_title': 'Nuevo reto social',
      'notifications_sample_social_body':
          'Dana te invito al reto de cardio de la comunidad. Acepta y suma XP extra!',
      'notifications_sample_social_type': 'Social',
      'notifications_sample_health_title': 'Recordatorio de hidratacion',
      'notifications_sample_health_body':
          'Aun te faltan 600ml para cumplir tu meta diaria.',
      'notifications_sample_health_type': 'Salud',
      'evaluation_phase_prefix': 'Fase',
      'evaluation_phase_calibrating': 'Calibracion',
      'evaluation_phase_ready': 'Listo',
      'evaluation_phase_recording': 'Grabacion',
      'evaluation_phase_reviewing': 'Revision',
      'evaluation_action_start': 'Iniciar evaluacion',
      'evaluation_action_finish': 'Finalizar',
      'evaluation_action_reset': 'Restablecer',
      'evaluation_live_title': 'Feedback en vivo',
      'evaluation_live_ready':
          'Listo para empezar, ajusta postura y luz.',
      'evaluation_feedback_back_title': 'Espalda neutra',
      'evaluation_feedback_back_body':
          'Manten la alineacion, excelente ejecucion.',
      'evaluation_feedback_knees_title': 'Rodillas',
      'evaluation_feedback_knees_body':
          'Evita que se proyecten hacia adentro durante la bajada.',
      'evaluation_feedback_cadence_title': 'Cadencia',
      'evaluation_feedback_cadence_body':
          'Controla la velocidad de bajada a 2s y subida a 1s.',
      'evaluation_cue_posture': 'Postura',
      'evaluation_cue_range': 'Rango',
      'evaluation_cue_speed': 'Ritmo',
      'evaluation_summary_title': 'Resumen de sesion',
      'evaluation_save_history': 'Guardar en historial',
      'onboarding_title': 'Configura tu experiencia',
      'onboarding_language_title':
          'En que idioma quieres usar FreeT?',
      'onboarding_theme_title': 'Selecciona un tema visual',
      'onboarding_devices_title': 'Conecta tus dispositivos',
      'onboarding_devices_band_title': 'Sincronizar FreeT Band Pro',
      'onboarding_devices_band_subtitle':
          'Recoge frecuencia cardiaca y pasos en tiempo real',
      'onboarding_devices_sensor_title': 'Sincronizar sensor de postura',
      'onboarding_devices_sensor_subtitle':
          'Recibe feedback avanzado durante tus rutinas',
      'onboarding_devices_manual': 'Configurar manualmente',
      'onboarding_summary_title': 'Todo listo',
      'onboarding_summary_devices': 'Dispositivos conectados',
      'onboarding_summary_devices_connected':
          'Band Pro y sensor de postura',
      'onboarding_summary_devices_pending': 'Pendiente de configurar',
      'onboarding_summary_note':
          'Podras ajustar estas preferencias en cualquier momento desde More > Settings.',
      'routines_title': 'Tus rutinas',
      'routines_generate_ai': 'Generar IA',
      'routines_generating': 'Generando...',
      'routines_autogeneration_title': 'Autogeneracion de rutinas',
      'routines_autogeneration_subtitle':
          'Programa nuevas rutinas en funcion de tus objetivos',
      'routines_frequency': 'Frecuencia',
      'routines_last_generated': 'Ultima',
      'routines_load_error': 'No fue posible cargar tus rutinas.',
      'routines_empty_title': 'Aun no tienes rutinas con este enfoque',
      'routines_empty_subtitle':
          'Genera una nueva rutina o cambia el filtro para ver mas opciones.',
      'routine_focus_all': 'Todos',
      'routine_focus_full': 'Completo',
      'routine_focus_leg': 'Pierna',
      'routine_focus_arm': 'Brazo',
      'routine_focus_cardio': 'Cardio',
      'routine_focus_custom': 'Personalizado',
      'routine_frequency_weekly': 'Semanal',
      'routine_frequency_monthly': 'Mensual',
      'routine_frequency_custom': 'Personalizado',
      'routine_bodyweight': 'Peso libre',
      'routine_recommended': 'Recomendado',
      'routine_sets_label': 'series',
      'routine_reps_label': 'repeticiones',
    },
    'pt': {
      'greeting': 'Ola,',
      'notifications': 'Notificacoes',
      'settings': 'Configuracoes',
      'social_active_rankings': 'Rankings ativos',
      'social_leaderboard_streak': 'Sequencias',
      'social_leaderboard_weight': 'Peso',
      'social_leaderboard_cardio': 'Cardio',
      'social_leaderboard_community': 'Comunidade',
      'social_load_error': 'Nao foi possivel carregar os rankings',
      'common_retry': 'Tentar novamente',
      'social_invite_friends': 'Convidar amigos',
      'social_score_label': 'Pontuacao',
      'social_score_change': 'Mudanca',
      'settings_theme_tab': 'Tema',
      'settings_language_tab': 'Idioma',
      'settings_notifications_tab': 'Notificacoes',
      'settings_theme_mode_title': 'Modo do tema',
      'settings_color_section': 'Cores personalizadas',
      'settings_primary_color': 'Primaria',
      'settings_secondary_color': 'Secundaria',
      'settings_select_language': 'Escolha o idioma',
      'settings_select_base_color': 'Escolha a cor base',
      'language_en': 'Ingles',
      'language_es': 'Espanhol',
      'language_pt': 'Portugues',
      'notifications_push': 'Push',
      'notifications_push_subtitle': 'Receba alertas no dispositivo',
      'notifications_email': 'Email',
      'notifications_email_subtitle': 'Resumo semanal e campanhas',
      'notifications_in_app': 'In-App',
      'notifications_in_app_subtitle': 'Banners e lembretes dentro do FreeT',
      'notifications_daily': 'Lembretes diarios',
      'notifications_weekly': 'Resumo semanal',
      'notifications_tips': 'Dicas personalizadas',
      'common_error_generic': 'Ocorreu um erro',
      'common_edit': 'Editar',
      'common_configure': 'Configurar',
      'common_back': 'Voltar',
      'common_next': 'Avancar',
      'common_finish': 'Concluir',
      'common_generate': 'Gerar',
      'common_generating': 'Gerando...',
      'common_refresh': 'Atualizar',
      'common_frequency': 'Frequencia',
      'common_last': 'Ultima',
      'time_minute_short': 'min',
      'time_hour_short': 'h',
      'time_day_short': 'd',
      'time_days_label': 'dias',
      'profile_load_error': 'Nao foi possivel carregar seu perfil',
      'profile_weight': 'Peso',
      'profile_height': 'Altura',
      'profile_linked_devices': 'Dispositivos vinculados',
      'profile_no_devices': 'Sem dispositivos conectados',
      'profile_device_type': 'Tipo',
      'profile_link_new_device': 'Vincular novo dispositivo',
      'profile_logout_success': 'Sessao encerrada com sucesso',
      'settings_preferences': 'Preferencias',
      'settings_telemetry_title': 'Telemetria e analise',
      'settings_telemetry_subtitle':
          'Configure metricas e paineis personalizados',
      'support_title': 'Suporte',
      'support_faq': 'FAQ e chamados',
      'support_faq_subtitle':
          'Consulte a base de conhecimento ou abra um chamado',
      'support_logout': 'Encerrar sessao',
      'dashboard_error':
          'Nao foi possivel carregar suas informacoes. Tente novamente.',
      'dashboard_attendance_registered': 'Presenca registrada',
      'dashboard_register_attendance': 'Registrar presenca',
      'dashboard_streak_banner':
          'Sequencia atualizada! Continue com esse ritmo.',
      'dashboard_summary_title': 'Resumo diario',
      'dashboard_summary_progress_title': 'Progresso diario',
      'dashboard_summary_progress_subtitle': 'Meta concluida',
      'dashboard_summary_streak_title': 'Sequencia ativa',
      'dashboard_summary_streak_subtitle': 'Sem ausencias',
      'dashboard_summary_calories_title': 'Calorias',
      'dashboard_summary_calories_subtitle': 'Estimativa de hoje',
      'dashboard_summary_readiness_title': 'Prontidao',
      'dashboard_summary_readiness_subtitle': 'Recuperacao',
      'dashboard_routine_title': 'Rotina de hoje',
      'dashboard_stats_title': 'Estatisticas',
      'dashboard_stats_latest': 'Ultimo valor',
      'dashboard_stats_goal': 'Meta',
      'dashboard_goals_title': 'Metas ativas',
      'dashboard_goal_current': 'Atual',
      'dashboard_goal_target': 'Meta',
      'dashboard_tips_title': 'Dicas personalizadas',
      'notifications_sample_routine_title': 'Rotina pronta',
      'notifications_sample_routine_body':
          'Sua rotina de perna para amanha ja esta gerada e pronta para revisar.',
      'notifications_sample_routine_type': 'Rotinas',
      'notifications_sample_social_title': 'Novo desafio social',
      'notifications_sample_social_body':
          'Dana convidou voce para o desafio de cardio da comunidade. Aceite e ganhe XP extra!',
      'notifications_sample_social_type': 'Social',
      'notifications_sample_health_title': 'Lembrete de hidratacao',
      'notifications_sample_health_body':
          'Ainda faltam 600ml para atingir sua meta diaria.',
      'notifications_sample_health_type': 'Saude',
      'evaluation_phase_prefix': 'Fase',
      'evaluation_phase_calibrating': 'Calibracao',
      'evaluation_phase_ready': 'Pronto',
      'evaluation_phase_recording': 'Gravacao',
      'evaluation_phase_reviewing': 'Revisao',
      'evaluation_action_start': 'Iniciar avaliacao',
      'evaluation_action_finish': 'Finalizar',
      'evaluation_action_reset': 'Redefinir',
      'evaluation_live_title': 'Feedback em tempo real',
      'evaluation_live_ready':
          'Pronto para comecar, ajuste postura e iluminacao.',
      'evaluation_feedback_back_title': 'Coluna neutra',
      'evaluation_feedback_back_body':
          'Manten o alinhamento, execucao excelente.',
      'evaluation_feedback_knees_title': 'Joelhos',
      'evaluation_feedback_knees_body':
          'Evite que se projetem para dentro durante a descida.',
      'evaluation_feedback_cadence_title': 'Cadencia',
      'evaluation_feedback_cadence_body':
          'Controle o ritmo: 2s descendo e 1s subindo.',
      'evaluation_cue_posture': 'Postura',
      'evaluation_cue_range': 'Amplitude',
      'evaluation_cue_speed': 'Ritmo',
      'evaluation_summary_title': 'Resumo da sessao',
      'evaluation_save_history': 'Salvar no historico',
      'onboarding_title': 'Configure sua experiencia',
      'onboarding_language_title':
          'Em que idioma deseja usar o FreeT?',
      'onboarding_theme_title': 'Escolha um tema visual',
      'onboarding_devices_title': 'Conecte seus dispositivos',
      'onboarding_devices_band_title': 'Sincronizar FreeT Band Pro',
      'onboarding_devices_band_subtitle':
          'Coleta frequencia cardiaca e passos em tempo real',
      'onboarding_devices_sensor_title': 'Sincronizar sensor de postura',
      'onboarding_devices_sensor_subtitle':
          'Receba feedback avancado durante suas rotinas',
      'onboarding_devices_manual': 'Configurar manualmente',
      'onboarding_summary_title': 'Tudo pronto',
      'onboarding_summary_devices': 'Dispositivos conectados',
      'onboarding_summary_devices_connected':
          'Band Pro e sensor de postura',
      'onboarding_summary_devices_pending': 'Pendente de configuracao',
      'onboarding_summary_note':
          'Voce pode ajustar essas preferencias a qualquer momento em More > Settings.',
      'routines_title': 'Suas rotinas',
      'routines_generate_ai': 'Gerar com IA',
      'routines_generating': 'Gerando...',
      'routines_autogeneration_title': 'Autogeracao de rotinas',
      'routines_autogeneration_subtitle':
          'Agende novas rotinas com base nos seus objetivos',
      'routines_frequency': 'Frequencia',
      'routines_last_generated': 'Ultima',
      'routines_load_error': 'Nao foi possivel carregar suas rotinas.',
      'routines_empty_title': 'Ainda nao ha rotinas para este foco',
      'routines_empty_subtitle':
          'Gere uma nova rotina ou mude o filtro para ver mais opcoes.',
      'routine_focus_all': 'Todas',
      'routine_focus_full': 'Corpo inteiro',
      'routine_focus_leg': 'Pernas',
      'routine_focus_arm': 'Bracos',
      'routine_focus_cardio': 'Cardio',
      'routine_focus_custom': 'Personalizada',
      'routine_frequency_weekly': 'Semanal',
      'routine_frequency_monthly': 'Mensal',
      'routine_frequency_custom': 'Personalizada',
      'routine_bodyweight': 'Peso corporal',
      'routine_recommended': 'Recomendado',
      'routine_sets_label': 'series',
      'routine_reps_label': 'repeticoes',
    },
  };

  String _translate(String key) {
    final languageCode = locale.languageCode;
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get greeting => _translate('greeting');
  String get notifications => _translate('notifications');
  String get settings => _translate('settings');
  String get socialActiveRankings => _translate('social_active_rankings');
  String get socialLoadError => _translate('social_load_error');
  String get commonRetry => _translate('common_retry');
  String get socialInviteFriends => _translate('social_invite_friends');
  String get socialScoreLabel => _translate('social_score_label');
  String get socialScoreChange => _translate('social_score_change');
  String get settingsThemeTab => _translate('settings_theme_tab');
  String get settingsLanguageTab => _translate('settings_language_tab');
  String get settingsNotificationsTab =>
      _translate('settings_notifications_tab');
  String get settingsThemeModeTitle => _translate('settings_theme_mode_title');
  String get settingsColorSection => _translate('settings_color_section');
  String get settingsPrimaryColor => _translate('settings_primary_color');
  String get settingsSecondaryColor => _translate('settings_secondary_color');
  String get settingsSelectLanguage => _translate('settings_select_language');
  String get settingsSelectBaseColor =>
      _translate('settings_select_base_color');
  String get notificationsPush => _translate('notifications_push');
  String get notificationsPushSubtitle =>
      _translate('notifications_push_subtitle');
  String get notificationsEmail => _translate('notifications_email');
  String get notificationsEmailSubtitle =>
      _translate('notifications_email_subtitle');
  String get notificationsInApp => _translate('notifications_in_app');
  String get notificationsInAppSubtitle =>
      _translate('notifications_in_app_subtitle');
  String get notificationsDaily => _translate('notifications_daily');
  String get notificationsWeekly => _translate('notifications_weekly');
  String get notificationsTips => _translate('notifications_tips');
  String get commonErrorGeneric => _translate('common_error_generic');
  String get commonEdit => _translate('common_edit');
  String get commonConfigure => _translate('common_configure');
  String get commonBack => _translate('common_back');
  String get commonNext => _translate('common_next');
  String get commonFinish => _translate('common_finish');
  String get commonGenerate => _translate('common_generate');
  String get commonGenerating => _translate('common_generating');
  String get commonRefresh => _translate('common_refresh');
  String get commonFrequency => _translate('common_frequency');
  String get commonLast => _translate('common_last');
  String get timeMinuteShort => _translate('time_minute_short');
  String get timeHourShort => _translate('time_hour_short');
  String get timeDayShort => _translate('time_day_short');
  String get timeDaysLabel => _translate('time_days_label');
  String get profileLoadError => _translate('profile_load_error');
  String get profileWeight => _translate('profile_weight');
  String get profileHeight => _translate('profile_height');
  String get profileLinkedDevices => _translate('profile_linked_devices');
  String get profileNoDevices => _translate('profile_no_devices');
  String get profileDeviceTypeLabel => _translate('profile_device_type');
  String get profileLinkNewDevice => _translate('profile_link_new_device');
  String get profileLogoutSuccess => _translate('profile_logout_success');
  String get settingsPreferences => _translate('settings_preferences');
  String get settingsTelemetryTitle =>
      _translate('settings_telemetry_title');
  String get settingsTelemetrySubtitle =>
      _translate('settings_telemetry_subtitle');
  String get supportTitle => _translate('support_title');
  String get supportFaq => _translate('support_faq');
  String get supportFaqSubtitle => _translate('support_faq_subtitle');
  String get supportLogout => _translate('support_logout');
  String get dashboardError => _translate('dashboard_error');
  String get dashboardAttendanceRegistered =>
      _translate('dashboard_attendance_registered');
  String get dashboardRegisterAttendance =>
      _translate('dashboard_register_attendance');
  String get dashboardStreakBanner =>
      _translate('dashboard_streak_banner');
  String get dashboardSummaryTitle =>
      _translate('dashboard_summary_title');
  String get dashboardSummaryProgressTitle =>
      _translate('dashboard_summary_progress_title');
  String get dashboardSummaryProgressSubtitle =>
      _translate('dashboard_summary_progress_subtitle');
  String get dashboardSummaryStreakTitle =>
      _translate('dashboard_summary_streak_title');
  String get dashboardSummaryStreakSubtitle =>
      _translate('dashboard_summary_streak_subtitle');
  String get dashboardSummaryCaloriesTitle =>
      _translate('dashboard_summary_calories_title');
  String get dashboardSummaryCaloriesSubtitle =>
      _translate('dashboard_summary_calories_subtitle');
  String get dashboardSummaryReadinessTitle =>
      _translate('dashboard_summary_readiness_title');
  String get dashboardSummaryReadinessSubtitle =>
      _translate('dashboard_summary_readiness_subtitle');
  String get dashboardRoutineTitle =>
      _translate('dashboard_routine_title');
  String get dashboardStatsTitle => _translate('dashboard_stats_title');
  String get dashboardStatsLatest =>
      _translate('dashboard_stats_latest');
  String get dashboardStatsGoal => _translate('dashboard_stats_goal');
  String get dashboardGoalsTitle => _translate('dashboard_goals_title');
  String get dashboardGoalCurrent =>
      _translate('dashboard_goal_current');
  String get dashboardGoalTarget => _translate('dashboard_goal_target');
  String get dashboardTipsTitle => _translate('dashboard_tips_title');
  String get notificationsSampleRoutineTitle =>
      _translate('notifications_sample_routine_title');
  String get notificationsSampleRoutineBody =>
      _translate('notifications_sample_routine_body');
  String get notificationsSampleRoutineType =>
      _translate('notifications_sample_routine_type');
  String get notificationsSampleSocialTitle =>
      _translate('notifications_sample_social_title');
  String get notificationsSampleSocialBody =>
      _translate('notifications_sample_social_body');
  String get notificationsSampleSocialType =>
      _translate('notifications_sample_social_type');
  String get notificationsSampleHealthTitle =>
      _translate('notifications_sample_health_title');
  String get notificationsSampleHealthBody =>
      _translate('notifications_sample_health_body');
  String get notificationsSampleHealthType =>
      _translate('notifications_sample_health_type');
  String get evaluationPhasePrefix =>
      _translate('evaluation_phase_prefix');
  String get evaluationActionStart =>
      _translate('evaluation_action_start');
  String get evaluationActionFinish =>
      _translate('evaluation_action_finish');
  String get evaluationActionReset =>
      _translate('evaluation_action_reset');
  String get evaluationLiveTitle => _translate('evaluation_live_title');
  String get evaluationLiveReady => _translate('evaluation_live_ready');
  String get evaluationFeedbackBackTitle =>
      _translate('evaluation_feedback_back_title');
  String get evaluationFeedbackBackBody =>
      _translate('evaluation_feedback_back_body');
  String get evaluationFeedbackKneesTitle =>
      _translate('evaluation_feedback_knees_title');
  String get evaluationFeedbackKneesBody =>
      _translate('evaluation_feedback_knees_body');
  String get evaluationFeedbackCadenceTitle =>
      _translate('evaluation_feedback_cadence_title');
  String get evaluationFeedbackCadenceBody =>
      _translate('evaluation_feedback_cadence_body');
  String get evaluationSummaryTitle =>
      _translate('evaluation_summary_title');
  String get evaluationSaveHistory =>
      _translate('evaluation_save_history');
  String get onboardingTitle => _translate('onboarding_title');
  String get onboardingLanguageTitle =>
      _translate('onboarding_language_title');
  String get onboardingThemeTitle => _translate('onboarding_theme_title');
  String get onboardingDevicesTitle =>
      _translate('onboarding_devices_title');
  String get onboardingDevicesBandTitle =>
      _translate('onboarding_devices_band_title');
  String get onboardingDevicesBandSubtitle =>
      _translate('onboarding_devices_band_subtitle');
  String get onboardingDevicesSensorTitle =>
      _translate('onboarding_devices_sensor_title');
  String get onboardingDevicesSensorSubtitle =>
      _translate('onboarding_devices_sensor_subtitle');
  String get onboardingDevicesManual =>
      _translate('onboarding_devices_manual');
  String get onboardingSummaryTitle =>
      _translate('onboarding_summary_title');
  String get onboardingSummaryDevices =>
      _translate('onboarding_summary_devices');
  String get onboardingSummaryDevicesConnected =>
      _translate('onboarding_summary_devices_connected');
  String get onboardingSummaryDevicesPending =>
      _translate('onboarding_summary_devices_pending');
  String get onboardingSummaryNote =>
      _translate('onboarding_summary_note');
  String get routinesTitle => _translate('routines_title');
  String get routinesGenerateAi => _translate('routines_generate_ai');
  String get routinesGenerating => _translate('routines_generating');
  String get routinesAutogenerationTitle =>
      _translate('routines_autogeneration_title');
  String get routinesAutogenerationSubtitle =>
      _translate('routines_autogeneration_subtitle');
  String get routinesFrequency => _translate('routines_frequency');
  String get routinesLastGenerated =>
      _translate('routines_last_generated');
  String get routinesLoadError => _translate('routines_load_error');
  String get routinesEmptyTitle => _translate('routines_empty_title');
  String get routinesEmptySubtitle =>
      _translate('routines_empty_subtitle');
  String get routineBodyweight => _translate('routine_bodyweight');
  String get routineRecommended =>
      _translate('routine_recommended');
  String get routineSetsLabel => _translate('routine_sets_label');
  String get routineRepsLabel => _translate('routine_reps_label');

  String leaderboardLabel(String type) {
    return _translate('social_leaderboard_$type');
  }

  String languageLabel(String languageCode) {
    return _translate('language_$languageCode');
  }

  String errorWithDetails(Object error) =>
      '$commonErrorGeneric: $error';

  String evaluationPhaseLabel(String phase) =>
      _translate('evaluation_phase_$phase');

  String evaluationCueLabel(String cue) =>
      _translate('evaluation_cue_$cue');

  String routineFocusLabel(String focus) =>
      _translate('routine_focus_$focus');

  String routineFrequencyLabel(String frequency) =>
      _translate('routine_frequency_$frequency');

  String routineSetsReps(int sets, int reps) =>
      '$sets $routineSetsLabel, $reps $routineRepsLabel';

  String timeDays(int count) => '$count $timeDaysLabel';

  String formatNumber(double value) => value.toStringAsFixed(0);

  String formatSigned(double value) {
    final formatted = value.toStringAsFixed(0);
    return value >= 0 ? '+$formatted' : formatted;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
