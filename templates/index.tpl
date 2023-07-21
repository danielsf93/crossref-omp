{**
 * plugins/importexport/crossref/templates/index.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * List of operations this plugin can perform
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
		<li><a href="#settings-tab">{translate key="plugins.importexport.common.settings"}</a></li>
		{if $allowExport}
			<li><a href="#exportSubmissions-tab">{translate key="plugins.importexport.common.export.articles"}</a></li>
		{/if}
	</ul>
	<div id="settings-tab">
		{if !$allowExport}
			<div class="pkp_notification" id="crossrefConfigurationErrors">
				{foreach from=$configurationErrors item=configurationError}
					{if $configurationError == $smarty.const.DOI_EXPORT_CONFIG_ERROR_DOIPREFIX}
						{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass="notifyWarning" notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.common.error.DOIsNotAvailable"|translate}
					{elseif $configurationError == $smarty.const.EXPORT_CONFIG_ERROR_SETTINGS}
						{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass="notifyWarning" notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.common.error.pluginNotConfigured"|translate}
					{/if}
				{/foreach}
				{**if !$currentContext->getData('publisherInstitution')}
					{capture assign=journalSettingsUrl}{url router=$smarty.const.ROUTE_PAGE page="management" op="settings" path="context" escape=false}{/capture}
					{capture assign=missingPublisherMessage}{translate key="plugins.importexport.crossref.error.publisherNotConfigured" journalSettingsUrl=$journalSettingsUrl}{/capture}
					{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass="notifyWarning" notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents=$missingPublisherMessage}
				{/if*}
				{*if !$currentContext->getData('onlineIssn') && !$currentContext->getData('printIssn')}
					{capture assign=journalSettingsUrl}{url router=$smarty.const.ROUTE_PAGE page="management" op="settings" path="context" escape=false}{/capture}
					{capture assign=missingIssnMessage}{translate key="plugins.importexport.crossref.error.issnNotConfigured" journalSettingsUrl=$journalSettingsUrl}{/capture}
					{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass="notifyWarning" notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents=$missingIssnMessage}
				{/if*}
				{if !$exportArticles}
					{include file="controllers/notification/inPlaceNotificationContent.tpl" notificationId=crossrefConfigurationErrors notificationStyleClass="notifyWarning" notificationTitle="plugins.importexport.common.missingRequirements"|translate notificationContents="plugins.importexport.crossref.error.noDOIContentObjects"|translate}
				{/if}
			</div>
		{/if}

		{capture assign=crossrefSettingsGridUrl}{url router=$smarty.const.ROUTE_COMPONENT component="grid.settings.plugins.settingsPluginGridHandler" op="manage" plugin="CrossRefExportPlugin" category="importexport" verb="index" escape=false}{/capture}
		{load_url_in_div id="crossrefSettingsGridContainer" url=$crossrefSettingsGridUrl}
	</div>

	{if $allowExport}
		<div id="exportSubmissions-tab">
		
			<script type="text/javascript">
				$(function() {ldelim}
					// Attach the form handler.
					$('#exportSubmissionXmlForm').pkpHandler('$.pkp.controllers.form.FormHandler');
				{rdelim});
			</script>
			<form id="exportSubmissionXmlForm" class="pkp_form" action="{plugin_url path="exportSubmissions"}" method="post">
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
										type="checkbox"
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
						<pkp-button :disabled="!components.submissions.itemsMax" @click="toggleSelectAll">
							<template v-if="components.submissions.itemsMax && selectedSubmissions.length >= components.submissions.itemsMax">
								{translate key="common.selectNone"}
							</template>
							<template v-else>
								{translate key="common.selectAll"}
							</template>
						</pkp-button>
						{*<pkp-button @click="submit('#exportXmlForm')">
							{translate key="ola"}
						</pkp-button>*}
					{/fbvFormSection}
				{/fbvFormArea}
					
					






					{fbvFormSection list="true"}
						{fbvElement type="checkbox" id="validation" label="plugins.importexport.crossref.settings.form.validation" checked=$validation|default:false}
					{/fbvFormSection}
					{if !empty($actionNames)}
						{fbvFormSection}
						<ul class="export_actions">
							{foreach from=$actionNames key=action item=actionName}
								<li class="export_action">
									{fbvElement type="submit" label="$actionName" id="$action" name="$action" value="1" class="$action" translate=false inline=true}
								</li>
							{/foreach}
						</ul>
						{/fbvFormSection}
					{/if}
				{/fbvFormArea}
			</form>
			<p>{translate key="plugins.importexport.crossref.statusLegend"}</p>
		</div>
	{/if}
</div>

{/block}
