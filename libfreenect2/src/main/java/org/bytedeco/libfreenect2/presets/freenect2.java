/*
 * Copyright (C) 2016-2020 Jérémy Laviole, Samuel Audet
 *
 * Licensed either under the Apache License, Version 2.0, or (at your option)
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation (subject to the "Classpath" exception),
 * either version 2, or any later version (collectively, the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     http://www.gnu.org/licenses/
 *     http://www.gnu.org/software/classpath/license.html
 *
 * or as provided in the LICENSE.txt file that accompanied this code.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.bytedeco.libfreenect2.presets;

import org.bytedeco.javacpp.Loader;
import org.bytedeco.javacpp.annotation.Platform;
import org.bytedeco.javacpp.annotation.Properties;
import org.bytedeco.javacpp.presets.javacpp;
import org.bytedeco.javacpp.tools.BuildEnabled;
import org.bytedeco.javacpp.tools.Info;
import org.bytedeco.javacpp.tools.InfoMap;
import org.bytedeco.javacpp.tools.InfoMapper;
import org.bytedeco.javacpp.tools.Logger;

/**
 * @author Jeremy Laviole
 * 
 */
@Properties(inherit = javacpp.class, target = "org.bytedeco.libfreenect2", global = "org.bytedeco.libfreenect2.global.freenect2", value = {
    @Platform(value = {"linux-x86", "linux-arm64", "macosx-x86_64", "windows-x86_64"}, include = {"<libfreenect2/libfreenect2.hpp>",
                "<libfreenect2/frame_listener.hpp>", "<libfreenect2/frame_listener_impl.h>", "<libfreenect2/logger.h>",
                "<libfreenect2/packet_pipeline.h>", "<libfreenect2/registration.h>", "<libfreenect2/config.h>"},
            link = "freenect2@.0.2"),
    @Platform(value = "linux-arm64", preload = "libusb-1.0", preloadpath = {"/usr/aarch64-linux-gnu/lib/", "/usr/lib/aarch64-linux-gnu/"}),
    @Platform(value = "macosx-x86_64", preload = "usb-1.0@.0", preloadpath = "/usr/local/lib/"),
    @Platform(value = "windows-x86_64", preload = {"libusb-1.0", "glfw3", "turbojpeg", "freenect2-openni2"}) })
public class freenect2 implements BuildEnabled, InfoMapper {
    static { Loader.checkVersion("org.bytedeco", "libfreenect2"); }
    
    private Logger log;
    private java.util.Properties props;
    private String encoding;

    @Override
    public void init(Logger log, java.util.Properties props, String encoding) {
        this.log = log;
        this.props = props;
        this.encoding = encoding;
    }

    public void map(InfoMap infoMap) {
        //System.getProperties().list(System.out);
        log.info("x-={[X]}=-x | Mapping libfreenect2 (OpenCL disabled) for '" + props.getProperty("platform") + "'...");
        infoMap.put(new Info("LIBFREENECT2_WITH_OPENCL_SUPPORT").define(false));
        
        switch (props.getProperty("platform")){
            case "windows-x86_64": case "linux-x86_64":
                log.info("x-={[X]}=-x | Including CUDA in mapping...");
                infoMap.put(new Info("LIBFREENECT2_WITH_CUDA_SUPPORT").define(true));
                break;
            default:
                log.info("x-={[X]}=-x | Ignoring CUDA...");
                infoMap.put(new Info("LIBFREENECT2_WITH_CUDA_SUPPORT").define(false));
                break;
        }

        infoMap.put(new Info("libfreenect2::Frame::Type").valueTypes("@Cast(\"libfreenect2::Frame::Type\") int"))
               .put(new Info("std::map<libfreenect2::Frame::Type,libfreenect2::Frame*>").pointerTypes("FrameMap").define())
               .put(new Info("LIBFREENECT2_API").skip());
    }
}
