with text_io,integer_io;               use text_io,integer_io;
with Multitasking,Semaphore;

procedure ts_jobs is

-- DESCRIPTION :
--   Prompts the user for the number of threads, the number of jobs,
--   and launches as many tasks as the number given.

  cnt : natural := 0;

  procedure Start_Workers ( n,m : in natural ) is

  -- DESCRIPTION :
  --   Starts n tasks to do m jobs.

    procedure do_next_job ( i,n : in natural ) is

    -- DESCRIPTION :
    --   Increases the job counter and does the next job if
    --   the counter is still less than or equal to m.
    --   After each critical section, a message is printed.

      s : Semaphore.Lock;
      myjob : natural;

    begin
      loop
        Semaphore.Request(s);
        cnt := cnt + 1; myjob := cnt;
        Semaphore.Release(s);
        if myjob <= m then
           put_line("Worker " & Multitasking.to_string(i)
            & " will do job " & Multitasking.to_string(myjob) & ".");
           delay 1.0;
        else
          put_line("No more jobs for worker " & Multitasking.to_string(i)
            & ".");
        end if;
        exit when (myjob > m);
      end loop;
    end do_next_job;
    procedure do_jobs is new Multitasking.Reporting_Workers(do_next_job);

  begin
    do_jobs(n);
  end Start_Workers;

  procedure Main is

    n,m : natural;

  begin
    put("Give the number of workers : "); get(n);
    put("Give the number of jobs : "); get(m);
    Start_Workers(n,m);
  end Main;

begin
  Main;
end ts_jobs;
