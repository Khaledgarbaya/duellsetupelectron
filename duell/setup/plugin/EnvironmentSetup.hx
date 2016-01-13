/*
 * Copyright (c) 2003-2015, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package duell.setup.plugin;

import duell.helpers.LogHelper;
import duell.helpers.CommandHelper;
import duell.helpers.DuellConfigHelper;
import duell.objects.DuellLib;

import haxe.io.Path;

class EnvironmentSetup
{
    public static inline var NODEJS_VERSION = "master";

    public function new()
    {

    }

    public function setup(): String
    {
        LogHelper.info("");
        LogHelper.info("\x1b[2m------");
        LogHelper.info("Electron Setup");
        LogHelper.info("------\x1b[0m");
        LogHelper.info("");

        installDuellNodeJS();
        LogHelper.println("");

        setupDuellNodeJS();
        LogHelper.println("");

        installElectronPackage();
        LogHelper.println("");

        LogHelper.info("\x1b[2m------");
        LogHelper.info("end");
        LogHelper.info("------\x1b[0m");

        return "success";
    }

    private function installDuellNodeJS(): Void
    {
        return;
        var duellLib = DuellLib.getDuellLib("nodejs", NODEJS_VERSION);
        if (duellLib.isInstalled())
        {
            LogHelper.info(" - installing duell nodejs library");
            duellLib.install();
        }
        else if (duellLib.updateNeeded())
        {
            LogHelper.info(" - updating duell nodejs library");
            duellLib.update();
        }
    }

    private function setupDuellNodeJS(): Void
    {
        LogHelper.info(" - setting up duell nodejs library");
        CommandHelper.runHaxelib("", ["run", "duell_duell", "run", "nodejs", "-setup"],
        {
            logOnlyIfVerbose: false
        });
    }

    private function installElectronPackage(): Void
    {
        LogHelper.info(" - installing electron node package");

        var electronNodeFolder = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), "electron"]);

        CommandHelper.runHaxelib("", ["run", "duell_duell", "run", "nodejs", "-npm", "config", "set", "prefix", electronNodeFolder],
        {
            logOnlyIfVerbose: false
        });

        CommandHelper.runHaxelib("", ["run", "duell_duell", "run", "nodejs", "-npm", "install", "electron-prebuilt", "-g"],
        {
            logOnlyIfVerbose: false
        });
    }
}
