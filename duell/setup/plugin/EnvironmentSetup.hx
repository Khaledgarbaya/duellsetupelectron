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

import duell.helpers.PlatformHelper;
import duell.helpers.AskHelper;
import duell.helpers.DownloadHelper;
import duell.helpers.ExtractionHelper;
import duell.helpers.PathHelper;
import duell.helpers.LogHelper;
import duell.helpers.StringHelper;
import duell.helpers.CommandHelper;
import duell.helpers.HXCPPConfigXMLHelper;
import duell.helpers.DuellConfigHelper;

import duell.objects.HXCPPConfigXML;

import haxe.io.Path;
import sys.FileSystem;

using StringTools;

class EnvironmentSetup
{
    /* Common Binaries */
    private static var npmAllOSBinaryUrl: String = "http://nodejs.org/download/release/npm/npm-1.1.0-1.zip";

    /*Mac Binaries*/
    private static var electronMacBinary          = "http://github.com/atom/electron/releases/download/v0.32.3/electron-v0.32.3-darwin-x64.zip";
    private static var iojsMacBinary              = "http://iojs.org/dist/latest/iojs-v3.3.1-darwin-x64.tar.gz";

    /* Windows Binaries */
    /// common
    private static var electronWindowsBinary      = "http://github.com/atom/electron/releases/download/v0.32.3/electron-v0.32.3-win32-x64-symbols.zip";
    /// x64 architecture
    private static var iosjsWin64Binary           = "http://iojs.org/dist/v3.3.1/win-x64/iojs.exe";
    private static var iosjsWin64LibBinary        = "http://iojs.org/dist/v3.3.1/win-x64/iojs.lib";
    /// x86 architecture
    private static var iosjsWin32Binary           = "http://iojs.org/dist/v3.3.1/win-x86/iojs.exe";
    private static var iosjsWin32LibBinary        = "http://iojs.org/dist/v3.3.1/win-x86/iojs.lib";

    /// hxnodejs
    private static var hxNodeJSRepoUrl: String    = "git@github.com:HaxeFoundation/hxnodejs.git";

    /*Variables setup*/
    private var electronBinaryPath: String        = null;
    private var npmBinaryPath: String             = null;
    private var iojsBinaryPath: String            = null;
    private var iojsLibBinaryPath: String         = null;
    private var hxcppConfigPath: String           = null;
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

        installHaxeNode();
        LogHelper.println("");

        downloadNpmBinary();
        LogHelper.println("");

        downloadIojsBinaries();
        LogHelper.println("");

        downloadElectronBinary();
        LogHelper.println("");

        setupHXCPP();

        LogHelper.info("\x1b[2m------");
        LogHelper.info("end");
        LogHelper.info("------\x1b[0m");

        return "success";
    }
    private function installHaxeNode(): Void
    {
        var targetPath: String = Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), "lib"]);
        var defaultHxNodeJSLibPath: String = Path.join([targetPath, "lib", "hxnodejs"]);
        var hxnodejsPath: String = ""

        var cloneAnswer = AskHelper.askYesOrNo("[Required]clone hxnodejs library from "+ hxNodeJSRepoUrl +"?");
        var hxNodeJSLibPath = AskHelper.askString("hxnodejs library Location", defaultHxNodeJSLibPath);

        if(hxnodejsPath == "")
            hxnodejsPath = defaultHxNodeJSLibPath;

        hxnodejsPath = resolvePath(hxnodejsPath);
        if (cloneAnswer)
        {
            if(FileSystem.exists(hxnodejsPath))
            {
                FileSystem.deleteDirectory(hxnodejsPath);
            }
            CommandHelper.runCommand(targetPath, "git", ["clone", hxNodeJSRepoUrl], {errorMessage: "doawloading hxnodejs Lib"});
            CommandHelper.runCommand(Path.join([targetPath, "lib", "hxnodejs"]), "haxelib",
                                    ["dev", "hxnodejs", "."], {errorMessage: "setting hxnodejs as dev lib"});
        }

        CommandHelper.runCommand(targetPath, "git", ["clone", hxNodeJSRepoUrl], {errorMessage: "doawloading hxnodejs Lib"});
        CommandHelper.runCommand(Path.join([targetPath, "lib", "hxnodejs"]), "haxelib",
                                ["dev", "hxnodejs", "."], {errorMessage: "setting hxnodejs as dev lib"});
    }

    private function downloadNpmBinary(): Void
    {
        var npmDownloadUrl: String = npmAllOSBinaryUrl;
        var defaultInstallPathForNpm = haxe.io.Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), "SDKs", "npm"]);

        var downloadAnswer = AskHelper.askYesOrNo("Download and install the npm Binary?");

        npmBinaryPath = AskHelper.askString("npm Binary Location", defaultInstallPathForNpm);

        npmBinaryPath = npmBinaryPath.trim();

        if(npmBinaryPath == "")
            npmBinaryPath = defaultInstallPathForNpm;

        npmBinaryPath = resolvePath(npmBinaryPath);

        if(downloadAnswer)
        {
            /// the actual download
            DownloadHelper.downloadFile(npmDownloadUrl);

            /// create the directory
            PathHelper.mkdir(npmBinaryPath);

            /// the extraction
            ExtractionHelper.extractFile(Path.withoutDirectory(npmDownloadUrl), npmBinaryPath, "");
        }
    }

    private function downloadIojsBinaries()
    {
        var iojsDownloadUrl: String = "";
        var iosjsLibDownloadUrl: String = null;/// only needed in windows os
        var defaultInstallPathForIojs = haxe.io.Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), "SDKs", "iojs"]);

        /* Downloading ios js*/
        if (PlatformHelper.hostPlatform == Platform.WINDOWS)
        {
            iojsDownloadUrl = PlatformHelper.hostArchitecture == Architecture.X64 ? iosjsWin64Binary :  iosjsWin32Binary;
            iosjsLibDownloadUrl = PlatformHelper.hostArchitecture == Architecture.X64 ? iosjsWin64LibBinary :  iosjsWin32LibBinary;
        }
        else if (PlatformHelper.hostPlatform == Platform.MAC)
        {
            iojsDownloadUrl = iojsMacBinary;
            iosjsLibDownloadUrl = null;
        }
        var downloadAnswer = AskHelper.askYesOrNo("Download and install the IOJS Binaries?");

        /// ask for the instalation path
        iojsBinaryPath = AskHelper.askString("IOJS Binaries Location", defaultInstallPathForIojs);

        /// clean up a bit
        iojsBinaryPath = iojsBinaryPath.trim();

        if(iojsBinaryPath == "")
            iojsBinaryPath = defaultInstallPathForIojs;

        iojsBinaryPath = resolvePath(iojsBinaryPath);

        if(downloadAnswer && PlatformHelper.hostPlatform == Platform.WINDOWS)
        {
            PathHelper.mkdir(iojsBinaryPath);

            /// the actual download
            DownloadHelper.downloadFile(iojsDownloadUrl, Path.join([iojsBinaryPath, "iojs.exe"]));

            if(iosjsLibDownloadUrl != null)
                DownloadHelper.downloadFile(iosjsLibDownloadUrl, Path.join([iojsBinaryPath, "iojs.lib"]));
        }
        else if(downloadAnswer && PlatformHelper.hostPlatform == Platform.MAC)
        {
            PathHelper.mkdir(iojsBinaryPath);

            /// the actual download
            DownloadHelper.downloadFile(iojsDownloadUrl);

            /// the extraction
            ExtractionHelper.extractFile(Path.withoutDirectory(iojsDownloadUrl), iojsBinaryPath, "iojs-v3.3.1-darwin-x64");
        }
    }

    private function downloadElectronBinary()
    {
        /// variable setup
        var electronDownloadUrl = "";
        var defaultInstallPath = haxe.io.Path.join([DuellConfigHelper.getDuellConfigFolderLocation(), "SDKs", "electron"]);

        /// get the download url for the host platform
        if (PlatformHelper.hostPlatform == Platform.WINDOWS)
        {
            electronDownloadUrl = electronWindowsBinary;
        }
        else if (PlatformHelper.hostPlatform == Platform.MAC)
        {
            electronDownloadUrl = electronMacBinary;
        }

        var downloadAnswer = AskHelper.askYesOrNo("Download and install the Electron Binary?");

        /// ask for the instalation path
        electronBinaryPath = AskHelper.askString("Electron Binary Location", defaultInstallPath);

        /// clean up a bit
        electronBinaryPath = electronBinaryPath.trim();

        if(electronBinaryPath == "")
            electronBinaryPath = defaultInstallPath;

        electronBinaryPath = resolvePath(electronBinaryPath);

        if(downloadAnswer)
        {
            /// the actual download
            DownloadHelper.downloadFile(electronDownloadUrl);

            /// create the directory
            PathHelper.mkdir(electronBinaryPath);

            /// the extraction
            ExtractionHelper.extractFile(Path.withoutDirectory(electronDownloadUrl), electronBinaryPath, "");
        }
    }
    private function setupHXCPP()
    {
        hxcppConfigPath = HXCPPConfigXMLHelper.getProbableHXCPPConfigLocation();

        if(hxcppConfigPath == null)
        {
            throw "Could not find the home folder, no HOME variable is set. Can't find hxcpp_config.xml";
        }

        var hxcppXML = HXCPPConfigXML.getConfig(hxcppConfigPath);

        var existingDefines : Map<String, String> = hxcppXML.getDefines();

        var newDefines : Map<String, String> = getDefinesToWriteToHXCPP();

        LogHelper.println("\x1b[1mWriting new definitions to hxcpp config file\x1b[0m");

        for(def in newDefines.keys())
        {
            LogHelper.info("\x1b[1m        " + def + "\x1b[0m:" + newDefines.get(def));
        }

        for(def in existingDefines.keys())
        {
            if(!newDefines.exists(def))
            {
                newDefines.set(def, existingDefines.get(def));
            }
        }

        hxcppXML.writeDefines(newDefines);
    }

    private function getDefinesToWriteToHXCPP() : Map<String, String>
    {
        var defines = new Map<String, String>();

        if(FileSystem.exists(electronBinaryPath))
        {
            defines.set("ELECTRON_BIN", FileSystem.fullPath(electronBinaryPath));
        }
        else
        {
            throw "Path specified for electron binary doesn't exist!";
        }

        if(FileSystem.exists(npmBinaryPath))
        {
            defines.set("NPM_BIN", FileSystem.fullPath(npmBinaryPath));
        }
        else
        {
            throw "Path specified for npm binary doesn't exist!";
        }

        if(FileSystem.exists(iojsBinaryPath))
        {
            defines.set("IOJS_BIN", FileSystem.fullPath(iojsBinaryPath));
        }
        else
        {
            throw "Path specified for iojs binary doesn't exist!";
        }

        defines.set("ELECTRON_SETUP", "YES");

        return defines;
    }

    private function resolvePath(path: String): String
    {
        path = PathHelper.unescape(path);

        if (PathHelper.isPathRooted(path))
            return path;

        return Path.join([Sys.getCwd(), path]);
    }
}
