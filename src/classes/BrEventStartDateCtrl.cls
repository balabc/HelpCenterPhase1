public with sharing class BrEventStartDateCtrl {
    public Datetime startDate {get; set;}
    public String timezone {get; set;}
    public String locale {get; set;}

    public BrEventStartDateCtrl() {}

    public String getStartDateFormatted() {
        String dateFormat = getDateTimeFormat(locale);
        return ' ' + startDate.format(dateFormat, timezone);
    }

    public String getDateTimeFormat(String locale) {
        Map<String, String> localFormat = new Map<String, String>();
        localFormat.put('ar', 'dd/MM/yyyy hh:mm a');
        localFormat.put('ar_AE', 'dd/MM/yyyy hh:mm a');
        localFormat.put('ar_BH', 'dd/MM/yyyy hh:mm a');
        localFormat.put('ar_JO', 'dd/MM/yyyy hh:mm a');
        localFormat.put('ar_KW', 'dd/MM/yyyy hh:mm a');
        localFormat.put('ar_LB', 'dd/MM/yyyy hh:mm a');
        localFormat.put('ar_SA', 'dd/MM/yyyy hh:mm a');
        localFormat.put('be_BY', 'dd.MM.yyyy H:mm');
        localFormat.put('bg_BG', 'yyyy-M-d H:mm');
        localFormat.put('ca', 'dd/MM/yyyy HH:mm');
        localFormat.put('ca_ES', 'dd/MM/yyyy HH:mm');
        localFormat.put('ca_ES_EURO', 'dd/MM/yyyy HH:mm');
        localFormat.put('cs', 'd.M.yyyy H:mm');
        localFormat.put('cs_CZ', 'd.M.yyyy H:mm');
        localFormat.put('da', 'dd-MM-yyyy HH:mm');
        localFormat.put('da_DK', 'dd-MM-yyyy HH:mm');
        localFormat.put('de', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_AT', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_AT_EURO', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_CH', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_DE', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_DE_EURO', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_LU', 'dd.MM.yyyy HH:mm');
        localFormat.put('de_LU_EURO', 'dd.MM.yyyy HH:mm');
        localFormat.put('el_GR', 'd/M/yyyy h:mm a');
        localFormat.put('en_AU', 'd/MM/yyyy HH:mm');
        localFormat.put('en_B', 'M/d/yyyy h:mm a');
        localFormat.put('en_BM', 'M/d/yyyy h:mm a');
        localFormat.put('en_CA', 'dd/MM/yyyy h:mm a');
        localFormat.put('en_GB', 'dd/MM/yyyy HH:mm');
        localFormat.put('en_GH', 'M/d/yyyy h:mm a');
        localFormat.put('en_ID', 'M/d/yyyy h:mm a');
        localFormat.put('en_IE', 'dd/MM/yyyy HH:mm');
        localFormat.put('en_IE_EURO', 'dd/MM/yyyy HH:mm');
        localFormat.put('en_NZ', 'd/MM/yyyy HH:mm');
        localFormat.put('en_SG', 'M/d/yyyy h:mm a');
        localFormat.put('en_US', 'M/d/yyyy h:mm a');
        localFormat.put('en_ZA', 'yyyy/MM/dd hh:mm a');
        localFormat.put('es', 'd/MM/yyyy H:mm');
        localFormat.put('es_AR', 'dd/MM/yyyy HH:mm');
        localFormat.put('es_BO', 'dd-MM-yyyy hh:mm a');
        localFormat.put('es_CL', 'dd-MM-yyyy hh:mm a');
        localFormat.put('es_CO', 'd/MM/yyyy hh:mm a');
        localFormat.put('es_CR', 'dd/MM/yyyy hh:mm a');
        localFormat.put('es_EC', 'dd/MM/yyyy hh:mm a');
        localFormat.put('es_ES', 'd/MM/yyyy H:mm');
        localFormat.put('es_ES_EURO', 'd/MM/yyyy H:mm');
        localFormat.put('es_GT', 'd/MM/yyyy hh:mm a');
        localFormat.put('es_HN', 'MM-dd-yyyy hh:mm a');
        localFormat.put('es_MX', 'd/MM/yyyy hh:mm a');
        localFormat.put('es_PE', 'dd/MM/yyyy hh:mm a');
        localFormat.put('es_PR', 'MM-dd-yyyy hh:mm a');
        localFormat.put('es_PY', 'dd/MM/yyyy hh:mm a');
        localFormat.put('es_SV', 'MM-dd-yyyy hh:mm a');
        localFormat.put('es_UY', 'dd/MM/yyyy hh:mm a');
        localFormat.put('es_VE', 'dd/MM/yyyy hh:mm a');
        localFormat.put('et_EE', 'd.MM.yyyy H:mm');
        localFormat.put('fi', 'd.M.yyyy H:mm');
        localFormat.put('fi_FI', 'd.M.yyyy H:mm');
        localFormat.put('fi_FI_EURO', 'd.M.yyyy H:mm');
        localFormat.put('fr', 'dd/MM/yyyy HH:mm');
        localFormat.put('fr_BE', 'd/MM/yyyy H:mm');
        localFormat.put('fr_CA', 'yyyy-MM-dd HH:mm');
        localFormat.put('fr_CH', 'dd.MM.yyyy HH:mm');
        localFormat.put('fr_FR', 'dd/MM/yyyy HH:mm');
        localFormat.put('fr_FR_EURO', 'dd/MM/yyyy HH:mm');
        localFormat.put('fr_LU', 'dd/MM/yyyy HH:mm');
        localFormat.put('fr_MC', 'dd/MM/yyyy HH:mm');
        localFormat.put('hr_HR', 'yyyy.MM.dd HH:mm');
        localFormat.put('hu', 'yyyy.MM.dd. H:mm');
        localFormat.put('hy_AM', 'M/d/yyyy h:mm a');
        localFormat.put('is_IS', 'd.M.yyyy HH:mm');
        localFormat.put('it', 'dd/MM/yyyy H.mm');
        localFormat.put('it_CH', 'dd.MM.yyyy HH:mm');
        localFormat.put('it_IT', 'dd/MM/yyyy H.mm');
        localFormat.put('iw', 'HH:mm dd/MM/yyyy');
        localFormat.put('iw_IL', 'HH:mm dd/MM/yyyy');
        localFormat.put('ja', 'yyyy/MM/dd H:mm');
        localFormat.put('ja_JP', 'yyyy/MM/dd H:mm');
        localFormat.put('kk_KZ', 'M/d/yyyy h:mm a');
        localFormat.put('km_KH', 'M/d/yyyy h:mm a');
        localFormat.put('ko', 'yyyy. M. d a h:mm');
        localFormat.put('ko_KR', 'yyyy. M. d a h:mm');
        localFormat.put('lt_LT', 'yyyy.M.d HH.mm');
        localFormat.put('lv_LV', 'yyyy.d.M HH:mm');
        localFormat.put('ms_MY', 'dd/MM/yyyy h:mm a');
        localFormat.put('nl', 'd-M-yyyy H:mm');
        localFormat.put('nl_BE', 'd/MM/yyyy H:mm');
        localFormat.put('nl_NL', 'd-M-yyyy H:mm');
        localFormat.put('nl_SR', 'd-M-yyyy H:mm');
        localFormat.put('no', 'dd.MM.yyyy HH:mm');
        localFormat.put('no_NO', 'dd.MM.yyyy HH:mm');
        localFormat.put('pl', 'yyyy-MM-dd HH:mm');
        localFormat.put('pt', 'dd-MM-yyyy H:mm');
        localFormat.put('pt_AO', 'dd-MM-yyyy H:mm');
        localFormat.put('pt_BR', 'dd/MM/yyyy HH:mm');
        localFormat.put('pt_PT', 'dd-MM-yyyy H:mm');
        localFormat.put('ro_RO', 'dd.MM.yyyy HH:mm');
        localFormat.put('ru', 'dd.MM.yyyy H:mm');
        localFormat.put('sk_SK', 'd.M.yyyy H:mm');
        localFormat.put('sl_SI', 'd.M.y H:mm');
        localFormat.put('sv', 'yyyy-MM-dd HH:mm');
        localFormat.put('sv_SE', 'yyyy-MM-dd HH:mm');
        localFormat.put('th', 'M/d/yyyy h:mm a');
        localFormat.put('th_TH', 'd/M/yyyy, H:mm ?.');
        localFormat.put('tr', 'dd.MM.yyyy HH:mm');
        localFormat.put('ur_PK', 'M/d/yyyy h:mm a');
        localFormat.put('vi_VN', 'HH:mm dd/MM/yyyy');
        localFormat.put('zh', 'yyyy-M-d ah:mm');
        localFormat.put('zh_CN', 'yyyy-M-d ah:mm');
        localFormat.put('zh_HK', 'yyyy-M-d ah:mm');
        localFormat.put('zh_TW', 'yyyy/M/d a h:mm');
        return localFormat.get(locale);
    }
}