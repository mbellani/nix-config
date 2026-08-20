{ pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
in
{
  environment.etc."codex/config.toml".source = tomlFormat.generate "codex-system-config" {
    model = "gpt-5.6-sol";
    model_reasoning_effort = "medium";
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    mcp_servers.openaiDeveloperDocs.url = "https://developers.openai.com/mcp";

    apps.connector_openai_plugin_management.tools."plugin_management.uninstall_app".approval_mode =
      "approve";
  };
}
