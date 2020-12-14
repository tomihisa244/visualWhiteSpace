{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_WS (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\kmrm244-ms\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\kmrm244-ms\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.4.3\\WS-0.1.0.0-JWwL9UyhShI6KReaaxmwI3"
dynlibdir  = "C:\\Users\\kmrm244-ms\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.4.3"
datadir    = "C:\\Users\\kmrm244-ms\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.4.3\\WS-0.1.0.0"
libexecdir = "C:\\Users\\kmrm244-ms\\AppData\\Roaming\\cabal\\WS-0.1.0.0-JWwL9UyhShI6KReaaxmwI3\\x86_64-windows-ghc-8.4.3\\WS-0.1.0.0"
sysconfdir = "C:\\Users\\kmrm244-ms\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "WS_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "WS_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "WS_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "WS_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "WS_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "WS_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
