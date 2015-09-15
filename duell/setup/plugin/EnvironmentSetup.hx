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

import duell.helpers.PathHelper;

import haxe.io.Path;
import sys.FileSystem;

using StringTools;

class EnvironmentSetup
{
    /* Common Binaries */
    private static var npmAllOSBinaryPath = "https://nodejs.org/download/release/npm/npm-1.1.0-1.zip";

    /*Mac Binaries*/
    private static var electronMacBinary = "https://github.com/atom/electron/releases/download/v0.32.3/electron-v0.32.3-darwin-x64.zip";
    private static var iojsMacBinary = "https://iojs.org/dist/latest/iojs-v3.3.1-darwin-x64.tar.gz";

    /* Windows Binaries */
    /// common
    private static var electronWindowsBinary = "https://github.com/atom/electron/releases/download/v0.32.3/electron-v0.32.3-win32-x64-symbols.zip";
    /// x64 architecture
    private static var iosjsWin64Binary = "https://iojs.org/dist/v3.3.1/win-x64/iojs.exe";
    private static var iosjsWin64LibBinary = "https://iojs.org/dist/v3.3.1/win-x64/iojs.lib";
    /// x86 architecture
    private static var iosjsWin32Binary = "https://iojs.org/dist/v3.3.1/win-x86/iojs.exe";
    private static var iosjsWin32LibBinary = "https://iojs.org/dist/v3.3.1/win-x86/iojs.lib";

    public function new()
    {

    }

    public function setup() : String
    {
        LogHelper.info("");
        LogHelper.info("\x1b[2m------");
        LogHelper.info("Electron Setup");
        LogHelper.info("------\x1b[0m");
        LogHelper.info("");

        downloadNodeBinaries()
        downloadElectronBinary();

        LogHelper.println("");

        LogHelper.info("\x1b[2m------");
        LogHelper.info("end");
        LogHelper.info("------\x1b[0m");

        return "success";
    }

    private function downloadNodeBinaries()
    {
    }

    private function downloadElectronBinary()
    {
    }

    private function resolvePath(path : String) : String
    {
        path = PathHelper.unescape(path);

        if (PathHelper.isPathRooted(path))
            return path;

        return Path.join([Sys.getCwd(), path]);
    }
}
