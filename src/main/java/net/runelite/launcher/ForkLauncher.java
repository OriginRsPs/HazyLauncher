/*
 * Copyright (c) 2022, Adam <Adam@sigterm.info>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package net.runelite.launcher;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.management.ManagementFactory;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import net.runelite.launcher.beans.Bootstrap;

@Slf4j
class ForkLauncher
{
    static boolean canForkLaunch() {
        OS.OSType os = OS.getOs();

        if (os == OS.OSType.Linux) {
            String appimage = System.getenv("APPIMAGE");
            if (appimage != null) {
                return true;
            }
        }

        if (os == OS.OSType.Windows || os == OS.OSType.MacOS) {
            String command = getCommandForCurrentProcess();

            if (command.isEmpty()) {
                return false;
            }

            Path path = Paths.get(command);
            String name = path.getFileName().toString();
            return name.equals(Launcher.LAUNCHER_EXECUTABLE_NAME_WIN)
                    || name.equals(Launcher.LAUNCHER_EXECUTABLE_NAME_OSX);
        }

        return false;
    }

    private static String getCommandForCurrentProcess() {
        String osCommand = null;

        switch (OS.getOs()) {
            case Windows:
                osCommand = "wmic process where processid=" + ManagementFactory.getRuntimeMXBean().getName().split("@")[0] + " get ExecutablePath";
                break;
            case MacOS:
                osCommand = "ps -p " + ManagementFactory.getRuntimeMXBean().getName().split("@")[0] + " -o comm=";
                break;
            default:
                throw new IllegalStateException("Invalid os");
        }

        if (osCommand != null) {
            try {
                Process process = Runtime.getRuntime().exec(osCommand);
                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                String path = reader.readLine();

                if (path != null) {
                    return path.trim();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return "";
    }

    public static void launch(
            Bootstrap bootstrap,
            List<File> classpath,
            Collection<String> clientArgs,
            Map<String, String> jvmProps,
            List<String> jvmArgs) throws IOException {

        String osCommand = null;

        switch (OS.getOs()) {
            case Windows:
                osCommand = "wmic process where processid=" + ManagementFactory.getRuntimeMXBean().getName().split("@")[0] + " get ExecutablePath";
                break;
            case MacOS:
                osCommand = "ps -p " + ManagementFactory.getRuntimeMXBean().getName().split("@")[0] + " -o comm=";
                break;
            case Linux:
                osCommand = "readlink /proc/`echo $$`/exe";
                break;
            default:
                throw new IllegalStateException("invalid os");
        }

        if (osCommand != null) {
            try {
                Process process = Runtime.getRuntime().exec(osCommand);
                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                String path = reader.readLine();

                if (path != null) {
                    path = path.trim();

                    List<String> commands = new ArrayList<>();
                    commands.add(path);
                    commands.add("-c");
                    // ... (rest of the code)

                    // Use 'commands' as needed.

                    System.out.println("Running process: " + commands);

                    ProcessBuilder builder = new ProcessBuilder(commands);
                    builder.start();
                } else {
                    throw new IOException("Failed to determine the executable path.");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}