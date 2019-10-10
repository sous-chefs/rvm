## File inspired from https://github.com/jessfraz/branch-cleanup-action. Please refer to the documentation if needed
## Contributed By: Shreyas Bapat (hello@shreyasb.com)

## Workflow defines what we want to call a set of actions.
workflow "on pull request merge, delete the branch" {
  ## On pull_request defines that whenever a pull request event is fired this 
  ## workflow will be run.
  on = "pull_request"
  
  ## What is the ending action (or set of actions) that we are running. 
  ## Since we can set what actions "need" in our definition of an action,
  ## we only care about the last actions run here.
  resolves = ["branch cleanup"]
}

## This is our action, you can have more than one but we just have this one for 
## our example.
## I named it branch cleanup, and since it is our last action run it matches 
## the name in the resolves section above.
action "branch cleanup" {
  ## Uses defines what we are running, you can point to a repository like below 
  ## OR you can define a docker image.
  uses = "jessfraz/branch-cleanup-action@master"
  
  ## We need a github token so that when we call the github api from our
  ## scripts in the above repository we can authenticate and have permission 
  ## to delete a branch.
  secrets = ["GITHUB_TOKEN"]
}
