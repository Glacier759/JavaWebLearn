package com.glacier.function;

import org.apache.commons.io.FileUtils;

import java.io.File;

/**
 * Created by glacier on 14-10-21.
 */
public class CpuFunction {

    public static void main(String[] args) {
        try {
            CpuFunction obj = new CpuFunction();
            obj.getCpuJSON();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getCpuJSON() {
        try {
            String[] proc_stat_old = FileUtils.readLines(new File("/proc/stat")).get(0).split(" ");
            Thread.sleep(1000);
            String[] proc_stat_new = FileUtils.readLines(new File("/proc/stat")).get(0).split(" ");

            int co_time = addAll(proc_stat_old);
            int cn_time = addAll(proc_stat_new);

            int user_pass = Integer.parseInt(proc_stat_new[2]) - Integer.parseInt(proc_stat_old[2]);
            int sys_pass = Integer.parseInt(proc_stat_new[4]) - Integer.parseInt(proc_stat_old[4]);
            int cpu_pass = cn_time - co_time;

            double u_cpu_use = user_pass * 1.0 / cpu_pass;
            double k_cpu_use = sys_pass * 1.0 / cpu_pass;
            double a_cpu_use = u_cpu_use + k_cpu_use;

            String json = "{\"user\":\"" + u_cpu_use + "\",\"system\":\"" + k_cpu_use + "\",\"all_use\":\"" + a_cpu_use + "\"}";
            return json;
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private int addAll( String[] proc_stat_arr ) {
        int result = 0;
        for ( int i = 1; i < proc_stat_arr.length; i ++ ) {
            if ( proc_stat_arr[i].length() == 0 )
                continue;
            result += Integer.parseInt(proc_stat_arr[i]);
        }
        return result;
    }
}
