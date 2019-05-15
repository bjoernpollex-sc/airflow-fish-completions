function update-airflow-completions
    if test -z "$AIRFLOW_HOME"
	echo "AIRFLOW_HOME must be set for airflow to work"
	return
    end

    set completions_file "$AIRFLOW_HOME/.airflow-completions"

    if [ (count $argv) -eq 1 ]
	set dag $argv[1]
	printf "Loading tasks for DAG '%s' ... " $dag
	set tasks (airflow list_tasks $dag)
	printf "found %i tasks\n" (count $tasks)
	set task_list "$tasks[3..-1]"
	if test -e $completions_file; and grep -q "^$dag" $completions_file
	    sed -i '' -e "s/^$dag.*/$dag $task_list/" $completions_file
	else
	    echo $dag $task_list >> $completions_file	    
	end
    else
	rm -f $completions_file
	set dags (airflow list_dags)
	printf "Found %i DAGs\n" (count $dags)
	for dag in $dags[8..-1]
	    if test -n $dag
		printf "Loading tasks for DAG '%s' ... " $dag
		set tasks (airflow list_tasks $dag)
		printf "found %i tasks\n" (count $tasks)
		echo $dag $tasks[3..-1] >> $completions_file
	    end
	end
    end
end


function __update-airflow-completions-needs_dag
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 -a $cmd[1] = 'update-airflow-completions' ]
	return 0
    end
    return 1
end


function __airflow_needs_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 -a $cmd[1] = 'airflow' ]
	return 0
    end
    return 1
end


function __airflow_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 2 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end


function __airflow_tests_task
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 3 ]
    if [ $cmd[2] = 'test' ]
      return 0
    end
  end
  return 1
end


function __airflow_list_dags
    if [ -e $AIRFLOW_HOME/.airflow-completions ]
	for line in (cat $AIRFLOW_HOME/.airflow-completions)
	    set parts (string split --max 1 " " $line)
	    echo $parts[1]
	end
    end
end


function __airflow_list_tasks
    if [ -e $AIRFLOW_HOME/.airflow-completions ]
	set cmd (commandline -opc)
	set dag $cmd[3]
	set line (grep "^$dag" $AIRFLOW_HOME/.airflow-completions)
	set split_line (string split " " $line)
	for task in $split_line[2..-1]
	    echo $task
	end
    end
end


complete -c update-airflow-completions -e
complete -c update-airflow-completions -n '__update-airflow-completions-needs_dag' --no-files -a "(__airflow_list_dags)"

complete -c airflow -e
complete -c airflow -n '__airflow_needs_command' --no-files -a "clear backfill test"
complete -c airflow -n '__airflow_using_command test' --no-files -a "(__airflow_list_dags)"
complete -c airflow -n '__airflow_using_command clear' --no-files -a "(__airflow_list_dags)"
complete -c airflow -n '__airflow_using_command backfill' --no-files -a "(__airflow_list_dags)"
complete -c airflow -n '__airflow_tests_task' --no-files -a "(__airflow_list_tasks)"
