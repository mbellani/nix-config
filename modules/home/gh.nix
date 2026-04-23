{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.activation.installGhExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    GH="${pkgs.gh}/bin/gh"
    for ext in dlvhdr/gh-dash dlvhdr/gh-enhance xbow-engineering/gh-xbow; do
      name="''${ext#*/}"
      # Remove gh- prefix to get the short name gh uses
      short_name="''${name#gh-}"
      $GH extension remove "$short_name" 2>/dev/null || true
      $GH extension install "$ext" 2>/dev/null || true
    done
  '';

  programs.gh = {
    enable = true;

    # Enable git credential helper to avoid permission issues, without this
    # the gh auth login won't work correctly.
    gitCredentialHelper.enable = true;

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
        rv = "repo view";
        rl = "repo list";
      };
    };
  };

  xdg.configFile."gh-dash/config.yml".text = builtins.toJSON {
    prSections = [
      {
        title = "My Pull Requests";
        filters = "is:open author:@me";
      }
      {
        title = "Needs My Review";
        filters = "is:open review-requested:@me";
      }
      {
        title = "Involved";
        filters = "is:open involves:@me -author:@me";
      }
    ];
    issuesSections = [
      {
        title = "My Issues";
        filters = "is:open author:@me";
      }
      {
        title = "Assigned";
        filters = "is:open assignee:@me";
      }
      {
        title = "Involved";
        filters = "is:open involves:@me -author:@me";
      }
    ];
    repo = {
      branchesRefetchIntervalSeconds = 30;
      prsRefetchIntervalSeconds = 60;
    };
    defaults = {
      preview = {
        open = true;
        width = 50;
      };
      prsLimit = 20;
      prApproveComment = "LGTM";
      issuesLimit = 20;
      view = "prs";
      layout = {
        prs = {
          updatedAt.width = 5;
          createdAt.width = 5;
          repo.width = 20;
          author.width = 15;
          authorIcon.hidden = false;
          assignees = {
            width = 20;
            hidden = true;
          };
          base = {
            width = 15;
            hidden = true;
          };
          lines.width = 15;
        };
        issues = {
          updatedAt.width = 5;
          createdAt.width = 5;
          repo.width = 15;
          creator.width = 10;
          creatorIcon.hidden = false;
          assignees = {
            width = 20;
            hidden = true;
          };
        };
      };
      refetchIntervalMinutes = 30;
    };
    keybindings = {
      universal = [ ];
      issues = [ ];
      prs = [
        {
          key = "T";
          command = "gh enhance -R {{.RepoName}} {{.PrNumber}}";
        }
      ];
      branches = [ ];
    };
    repoPaths = { };
    theme.ui = {
      sectionsShowCount = true;
      table = {
        showSeparator = true;
        compact = false;
      };
    };
    pager.diff = "delta";
    confirmQuit = false;
    showAuthorIcons = true;
    smartFilteringAtLaunch = true;
  };
}
