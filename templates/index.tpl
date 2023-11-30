{**
 * plugins/importexport/crossref/templates/index.tpl
 *}
 {extends file="layouts/backend.tpl"}
 {block name="page"}

	{if !empty($configurationErrors) ||
	!$currentContext->getData('publisher')|escape || 
	!$exportArticles 
	}
	{assign var="allowExport" value=false}
{else}



	{assign var="allowExport" value=true}
{/if}

<script type="text/javascript">
	// Attach the JS file tab handler.
	$(function() {ldelim}
		$('#importExportTabs').pkpHandler('$.pkp.controllers.TabHandler');
	{rdelim});
</script>
<div id="importExportTabs">
	<ul>
		<li><a href="#settings-tab">{translate key="Credenciais"}</a></li>
		{if $allowExport}
			<li><a href="#exportSubmissions-tab">{translate key="Exportar Livro"}</a></li>
		{/if}
	</ul>

	<div id="settings-tab">
		
		{capture assign=crossrefSettingsGridUrl}{url router=$smarty.const.ROUTE_COMPONENT component="grid.settings.plugins.settingsPluginGridHandler" op="manage" plugin="CrossRefExportPlugin" category="importexport" verb="index" escape=false}{/capture}
		{load_url_in_div id="crossrefSettingsGridContainer" url=$crossrefSettingsGridUrl}
	</div>
	
		<div id="exportSubmissions-tab">
		
			<script type="text/javascript">
				$(function() {ldelim}
					// Attach the form handler.
					$('#exportSubmissionXmlForm').pkpHandler('$.pkp.controllers.form.FormHandler');
				{rdelim});
			</script>
			
			<form id="exportXmlForm" class="pkp_form" action="{plugin_url path="export"}" method="post">
				{csrf}
				<input type="hidden" name="tab" value="exportSubmissions-tab" />
				{fbvFormArea id="submissionsXmlForm"}
					{* RESPONSÁVEL PELA LISTA, baseado em Onix30:*}
					
					{csrf}
				{fbvFormArea id="exportForm"}
					<submissions-list-panel
						v-bind="components.submissions"
						@set="set"
					>

						<template v-slot:item="{ldelim}item{rdelim}">
							<div class="listPanel__itemSummary">
								<label>
									<input
										type="radio"
										name="selectedSubmissions[]"
										:value="item.id"
										v-model="selectedSubmissions"
									/>
									<span class="listPanel__itemSubTitle">
										{{ localize(item.publications.find(p => p.id == item.currentPublicationId).fullTitle) }}
									</span>
								</label>
								<pkp-button element="a" :href="item.urlWorkflow" style="margin-left: auto;">
									{{ __('common.view') }}
								</pkp-button>
							</div>
						</template>
					</submissions-list-panel>
					{fbvFormSection}
						<pkp-button :disabled="!components.submissions.itemsMax" >
							
						</pkp-button>

					<pkp-button @click="submit('#exportXmlForm')">
						{translate key="plugins.importexport.exml.exportSubmissions"}
					</pkp-button>
						
					{/fbvFormSection}
				{/fbvFormArea}

				{/fbvFormArea}
			</form>
			
		</div>
	
</div>

{/block}
