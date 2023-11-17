At this stage, you should be transferring the behavioral .csv file we'd generated from psychopy to the directory /data/Uncertainty/data/behav
However, I have not yet been able to successfully use scp to automatically transfer those files.
As such, I'd recommend using WinSCP and just doing it manually for now

# sudo scp -r /data/Uncertainty/data/behav/ tui81100@cla24636:S:\Helion_Group\studies\uncertainty\neuro\data\task\*.csv