{**
 * plugins/importexport/crossref/templates/settingsForm.tpl

 *}
<script type="text/javascript">
	$(function() {ldelim}
		// Attach the form handler.
		$('#crossrefSettingsForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
	{rdelim});
</script>
<form class="pkp_form" id="crossrefSettingsForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" plugin="CrossRefExportPlugin" category="importexport" verb="save"}">
	{csrf}
	
	{fbvFormArea id="crossrefSettingsFormArea"}
		<div class="pkp_notification">
		<div class="notifyWarning">
		<b> {translate key="Plugin de exportação eXML."}</b><br>
		-Adicione as informações como login e email de depositant crossref.<br>
		-Selecione a publicação a ser baixada e clique em exportar.<br>
		-Acesse a <a href="https://doi.crossref.org/servlet/useragent" target="_blank">ferramenta de deposito manual da Crossref </a>para depositar o arquivo xml.
		<br><br>Se possuir dúvidas sobre a ferramenta, acesse o 
		<a href="https://www.crossref.org/documentation/register-maintain-records/direct-deposit-xml/admin-tool/" target="_blank"> manual da Crossref </a>
		</div>
		</div>
		{fbvFormSection}
			{fbvElement type="text" id="depositorName" value=$depositorName required="true" label="Nome de Usuário" maxlength="60" size=$fbvStyles.size.MEDIUM}
			{fbvElement type="text" id="depositorEmail" value=$depositorEmail required="true" label="Email" maxlength="90" size=$fbvStyles.size.MEDIUM}
		{/fbvFormSection}
		
	{/fbvFormArea}
	{fbvFormButtons submitText="common.save"}
	<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</form>
