#!/bin/bash

# ============================================
# Video Creator Tool - Remotion Setup Script
# ============================================

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════╗"
echo "║   🎬 Video Creator Tool - Remotion Setup          ║"
echo "╚════════════════════════════════════════════════════╝"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*) OS="Linux";;
  Darwin*) OS="Mac";;
  CYGWIN*|MINGW*) OS="Windows";;
esac

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📋 Step 1: Checking System Requirements${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check Node.js
echo -n "Checking Node.js... "
if command -v node &> /dev/null; then
  NODE_VERSION=$(node -v)
  echo -e "${GREEN}✓ ${NODE_VERSION}${NC}"
else
  echo -e "${RED}✗ Node.js not found${NC}"
  echo "Install from: https://nodejs.org/"
  exit 1
fi

# Check npm
echo -n "Checking npm... "
if command -v npm &> /dev/null; then
  NPM_VERSION=$(npm -v)
  echo -e "${GREEN}✓ ${NPM_VERSION}${NC}"
else
  echo -e "${RED}✗ npm not found${NC}"
  exit 1
fi

# Check FFmpeg
echo -n "Checking FFmpeg... "
if command -v ffmpeg &> /dev/null; then
  echo -e "${GREEN}✓ Installed${NC}"
else
  echo -e "${YELLOW}⚠ FFmpeg not found${NC}"
  echo "Install with:"
  if [ "$OS" = "Mac" ]; then
    echo "  brew install ffmpeg"
  elif [ "$OS" = "Linux" ]; then
    echo "  sudo apt-get install ffmpeg"
  elif [ "$OS" = "Windows" ]; then
    echo "  choco install ffmpeg"
  fi
fi

# Check git
echo -n "Checking Git... "
if command -v git &> /dev/null; then
  GIT_VERSION=$(git --version)
  echo -e "${GREEN}✓ ${GIT_VERSION}${NC}"
else
  echo -e "${RED}✗ Git not found${NC}"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📁 Step 2: Creating Project Structure${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Create directories
echo "Creating directories..."
mkdir -p src
mkdir -p videos/output
mkdir -p .vscode
echo -e "${GREEN}✓ Directories created${NC}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📄 Step 3: Creating Configuration Files${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Create .gitignore
echo "Creating .gitignore..."
cat > .gitignore << 'EOF'
# Dependencies
node_modules
/.pnp
.pnp.js

# Production
/build
/dist
out

# Misc
.DS_Store
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Remotion cache
.remotion-cache

# Video outputs
videos/
temp_audio/
*.mp4
*.webm
*.gif

# IDE
.vscode
.idea
*.swp
*.swo
*~
EOF
echo -e "${GREEN}✓ .gitignore created${NC}"

# Create tsconfig.json
echo "Creating tsconfig.json..."
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF
echo -e "${GREEN}✓ tsconfig.json created${NC}"

# Create remotion.config.ts
echo "Creating remotion.config.ts..."
cat > remotion.config.ts << 'EOF'
import { Config } from 'remotion';

Config.setCodec('h264');
Config.setFps(60);
Config.setHeight(1080);
Config.setWidth(1920);
Config.setDurationInFrames(3600);
Config.setImageFormat('png');
Config.setQuality('high');
Config.setCrf(18);
EOF
echo -e "${GREEN}✓ remotion.config.ts created${NC}"

# Create package.json
echo "Creating package.json..."
cat > package.json << 'EOF'
{
  "name": "video-creator-remotion",
  "version": "2.0.0",
  "description": "Advanced video creation tool using Remotion with voice over",
  "main": "dist/index.js",
  "scripts": {
    "dev": "remotion preview",
    "build": "remotion render video-with-audio output.mp4",
    "create:video": "tsx src/video-creator-cli.ts",
    "create:topic": "tsx src/video-creator-cli.ts \"Chủ đề của bạn\" 60 vi",
    "render": "remotion render",
    "preview": "remotion preview",
    "build:production": "npm run build -- --codec h264 --crf 18"
  },
  "dependencies": {
    "remotion": "^4.0.0",
    "@remotion/cli": "^4.0.0",
    "@remotion/renderer": "^4.0.0",
    "chalk": "^5.3.0",
    "gtts": "^2.4.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "tsx": "^4.0.0"
  },
  "engines": {
    "node": ">=16.0.0"
  }
}
EOF
echo -e "${GREEN}✓ package.json created${NC}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📚 Step 4: Creating Source Files${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Create src/index.tsx
echo "Creating src/index.tsx..."
cat > src/index.tsx << 'EOF'
import { registerRoot } from 'remotion';
import { RemotionRoot } from './remotion-video-composition';

registerRoot(RemotionRoot);
EOF
echo -e "${GREEN}✓ src/index.tsx created${NC}"

# Create src/remotion-video-composition.tsx
echo "Creating src/remotion-video-composition.tsx..."
cat > src/remotion-video-composition.tsx << 'EOF'
import { useState } from 'react';
import {
  Composition,
  Folder,
  AbsoluteFill,
  Text,
  Img,
  Audio,
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
} from 'remotion';

interface VideoCompositionProps {
  topic: string;
  duration: number;
  backgroundColor: string;
  textColor: string;
  accentColor: string;
}

const VideoComposition: React.FC<VideoCompositionProps> = ({
  topic,
  duration,
  backgroundColor,
  textColor,
  accentColor,
}) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const titleOpacity = interpolate(frame, [0, fps * 0.5], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const titleScale = spring({
    frame: frame - fps * 0.2,
    config: { damping: 100, mass: 0.5, overshootClamping: true },
    fps,
  });

  const subtitleOpacity = interpolate(frame, [fps * 0.8, fps * 1.3], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const barTransform = interpolate(
    frame,
    [fps * 1.5, fps * 2],
    [100, 0],
    {
      extrapolateLeft: 'clamp',
      extrapolateRight: 'clamp',
    }
  );

  const rotation = (frame / fps) * 360;

  return (
    <AbsoluteFill style={{ backgroundColor }}>
      <svg
        style={{
          position: 'absolute',
          width: '100%',
          height: '100%',
        }}
      >
        <defs>
          <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor={backgroundColor} stopOpacity={1} />
            <stop offset="100%" stopColor={accentColor} stopOpacity={0.3} />
          </linearGradient>
        </defs>
        <rect width="100%" height="100%" fill="url(#gradient)" />
      </svg>

      <div
        style={{
          position: 'absolute',
          width: 300,
          height: 300,
          borderRadius: '50%',
          border: `3px solid ${accentColor}`,
          top: '10%',
          right: '10%',
          opacity: 0.3,
          transform: `rotate(${rotation}deg)`,
        }}
      />

      <Text
        style={{
          fontSize: 80,
          fontWeight: 'bold',
          color: textColor,
          textAlign: 'center',
          position: 'absolute',
          top: '35%',
          left: 0,
          right: 0,
          opacity: titleOpacity,
          transform: `scale(${titleScale})`,
          fontFamily: 'Arial, sans-serif',
          textShadow: `0 10px 30px rgba(0,0,0,0.3)`,
          maxWidth: '90%',
          marginLeft: 'auto',
          marginRight: 'auto',
          lineHeight: 1.2,
        }}
      >
        {topic}
      </Text>

      <Text
        style={{
          fontSize: 32,
          color: accentColor,
          textAlign: 'center',
          position: 'absolute',
          top: '55%',
          left: 0,
          right: 0,
          opacity: subtitleOpacity,
          fontFamily: 'Arial, sans-serif',
          fontWeight: '300',
        }}
      >
        Video được tạo tự động
      </Text>

      <div
        style={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          height: 8,
          background: `linear-gradient(90deg, ${accentColor}, ${backgroundColor})`,
          transform: `translateY(${barTransform}px)`,
        }}
      />

      <div
        style={{
          position: 'absolute',
          bottom: '10%',
          left: '5%',
          width: 50,
          height: 50,
          border: `2px solid ${accentColor}`,
          opacity: 0.5,
        }}
      />
      <div
        style={{
          position: 'absolute',
          top: '20%',
          left: '5%',
          width: 30,
          height: 30,
          border: `2px solid ${accentColor}`,
          opacity: 0.3,
        }}
      />
    </AbsoluteFill>
  );
};

interface VideoWithVoiceProps extends VideoCompositionProps {
  audioPath?: string;
}

export const VideoWithVoice: React.FC<VideoWithVoiceProps> = ({
  topic,
  duration,
  backgroundColor,
  textColor,
  accentColor,
  audioPath,
}) => {
  return (
    <AbsoluteFill>
      <VideoComposition
        topic={topic}
        duration={duration}
        backgroundColor={backgroundColor}
        textColor={textColor}
        accentColor={accentColor}
      />
      {audioPath && (
        <Audio src={audioPath} />
      )}
    </AbsoluteFill>
  );
};

export const RemotionRoot = () => {
  return (
    <>
      <Folder name="Video Templates">
        <Composition
          id="video-basic"
          component={VideoComposition}
          durationInFrames={1800}
          fps={60}
          width={1920}
          height={1080}
          defaultProps={{
            topic: 'Trí Tuệ Nhân Tạo',
            duration: 30,
            backgroundColor: '#0f0f1e',
            textColor: '#ffffff',
            accentColor: '#00d4ff',
          }}
        />
        <Composition
          id="video-with-audio"
          component={VideoWithVoice}
          durationInFrames={3600}
          fps={60}
          width={1920}
          height={1080}
          defaultProps={{
            topic: 'Python Programming',
            duration: 60,
            backgroundColor: '#0a0e27',
            textColor: '#ffffff',
            accentColor: '#ff6b9d',
            audioPath: '',
          }}
        />
      </Folder>
    </>
  );
};
EOF
echo -e "${GREEN}✓ src/remotion-video-composition.tsx created${NC}"

# Create src/video-creator-cli.ts
echo "Creating src/video-creator-cli.ts..."
cat > src/video-creator-cli.ts << 'EOF'
import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import { render } from '@remotion/renderer';
import chalk from 'chalk';

interface VideoCreatorOptions {
  topic: string;
  duration: number;
  language: string;
  outputDir: string;
  backgroundColor?: string;
  accentColor?: string;
  fps?: number;
  resolution?: [number, number];
}

class RemotionVideoCreator {
  private options: VideoCreatorOptions;

  constructor(options: VideoCreatorOptions) {
    this.options = {
      fps: 60,
      resolution: [1920, 1080],
      backgroundColor: '#0a0e27',
      accentColor: '#00d4ff',
      ...options,
    };
    this.ensureDirectories();
  }

  private ensureDirectories(): void {
    [this.options.outputDir, 'temp_audio', 'videos/output'].forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(chalk.green(`✓ Created directory: ${dir}`));
      }
    });
  }

  async generateVoiceOver(): Promise<string> {
    console.log(chalk.blue('🎙️  Generating voice over...'));

    const script = `
      Xin chào! Hôm nay chúng ta sẽ tìm hiểu về ${this.options.topic}.
      ${this.options.topic} là một chủ đề rất thú vị và có nhiều ứng dụng thực tiễn.
      Cảm ơn bạn đã xem video. Hãy subscribe để nhận thêm nhiều video hay!
    `;

    const audioPath = path.join('temp_audio', `voice_${Date.now()}.mp3`);

    try {
      const command = `gtts-cli "${script.trim()}" --lang ${this.options.language} --file "${audioPath}"`;
      execSync(command, { stdio: 'inherit' });
      console.log(chalk.green(`✓ Voice over generated: ${audioPath}`));
      return audioPath;
    } catch (error) {
      console.log(chalk.yellow('⚠️  Voice generation skipped. Install gtts-cli or use pre-recorded audio.'));
      return '';
    }
  }

  async renderVideo(audioPath: string): Promise<string> {
    console.log(chalk.blue('🎬 Rendering video with Remotion...'));

    const outputPath = path.join(
      this.options.outputDir,
      `video_${this.options.topic.replace(/\s+/g, '_')}_${Date.now()}.mp4`
    );

    try {
      const durationInFrames = this.options.duration * (this.options.fps || 60);

      await render({
        composition: 'video-with-audio',
        serveUrl: 'http://localhost:3000',
        codec: 'h264',
        crf: 18,
        fps: this.options.fps || 60,
        height: this.options.resolution?.[1] || 1080,
        width: this.options.resolution?.[0] || 1920,
        durationInFrames,
        outputLocation: outputPath,
        inputProps: {
          topic: this.options.topic,
          duration: this.options.duration,
          backgroundColor: this.options.backgroundColor,
          accentColor: this.options.accentColor,
          audioPath: audioPath || undefined,
          textColor: '#ffffff',
        },
      });

      console.log(chalk.green(`✓ Video rendered: ${outputPath}`));
      return outputPath;
    } catch (error) {
      console.error(chalk.red('✗ Rendering failed:'), error);
      throw error;
    }
  }

  async create(): Promise<string> {
    try {
      console.log(chalk.cyan.bold('🎯 Starting Video Creation Process'));
      console.log(chalk.gray(`Topic: ${this.options.topic}`));
      console.log(chalk.gray(`Duration: ${this.options.duration}s`));
      console.log(chalk.gray(`Language: ${this.options.language}`));
      console.log(chalk.gray('─'.repeat(50)));

      const audioPath = await this.generateVoiceOver();
      const videoPath = await this.renderVideo(audioPath);
      this.cleanup();

      console.log(chalk.gray('─'.repeat(50)));
      console.log(chalk.cyan.bold('✅ Video Creation Completed Successfully!'));
      console.log(chalk.green(`📁 Output: ${videoPath}`));

      return videoPath;
    } catch (error) {
      console.error(chalk.red('✗ Video creation failed:'), error);
      throw error;
    }
  }

  private cleanup(): void {
    console.log(chalk.blue('🧹 Cleaning up temporary files...'));
    try {
      if (fs.existsSync('temp_audio')) {
        fs.rmSync('temp_audio', { recursive: true });
        console.log(chalk.green('✓ Temp audio cleaned'));
      }
    } catch (error) {
      console.warn(chalk.yellow('⚠️  Cleanup warning:'), error);
    }
  }
}

async function main() {
  const args = process.argv.slice(2);
  const topic = args[0] || 'Công nghệ';
  const duration = parseInt(args[1]) || 60;
  const language = args[2] || 'vi';

  const creator = new RemotionVideoCreator({
    topic,
    duration,
    language,
    outputDir: './videos/output',
    backgroundColor: '#0a0e27',
    accentColor: '#00d4ff',
  });

  const videoPath = await creator.create();
  console.log(chalk.cyan(`\n📹 Video saved to: ${videoPath}`));
}

main().catch((error) => {
  console.error(chalk.red('Fatal error:'), error);
  process.exit(1);
});
EOF
echo -e "${GREEN}✓ src/video-creator-cli.ts created${NC}"

# Create README.md
echo "Creating README.md..."
cat > README.md << 'EOF'
# 📹 Video Creator Tool - Remotion Version

Advanced video creation tool using **Remotion** framework with professional animations and voice over support.

## ✨ Tính năng

- ✅ **Smooth Animations** - Spring animations, fade effects, scaling
- ✅ **Voice Over** - Tự động tạo voice bằng gTTS
- ✅ **Dynamic Content** - Nhập chủ đề, tự động generate video
- ✅ **High Quality** - Full HD 1920x1080 @ 60fps
- ✅ **Multiple Formats** - MP4, WebM, GIF support
- ✅ **Real-time Preview** - Xem preview trong khi phát triển
- ✅ **Professional Effects** - Gradient backgrounds, rotating elements
- ✅ **Customizable Colors** - Thay đổi background, accent colors

## 🚀 Installation

```bash
npm install
```

## 📖 Hướng dẫn Sử dụng

### 1. Chạy Preview Mode
```bash
npm run dev
```

### 2. Tạo Video bằng CLI
```bash
npm run create:video
```

### 3. Render Video Final
```bash
npm run build
```

## 📄 Giấy phép
MIT License 2024
EOF
echo -e "${GREEN}✓ README.md created${NC}"

# Create QUICK_START.md
echo "Creating QUICK_START.md..."
cat > QUICK_START.md << 'EOF'
# 🚀 Quick Start Guide

## 5 phút để tạo video đầu tiên

### Step 1: Cài đặt
```bash
npm install
```

### Step 2: Xem Preview
```bash
npm run dev
```
Mở http://localhost:3000 trong browser

### Step 3: Tạo Video
```bash
npm run create:video
```

### Step 4: Tìm Video Output
Video sẽ được lưu trong thư mục `videos/output/`

## Ví dụ

```bash
# Tạo video về "Machine Learning"
tsx src/video-creator-cli.ts "Machine Learning" 60 en

# Tạo video về "Blockchain" (60 giây)
tsx src/video-creator-cli.ts "Blockchain Technology" 60 vi
```
EOF
echo -e "${GREEN}✓ QUICK_START.md created${NC}"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📦 Step 5: Installing Dependencies${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo "Installing npm dependencies... (this may take a few minutes)"
npm install

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🎉 Setup Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo ""
echo -e "${GREEN}✓ Project structure created${NC}"
echo -e "${GREEN}✓ All files configured${NC}"
echo -e "${GREEN}✓ Dependencies installed${NC}"

echo ""
echo -e "${YELLOW}📖 Next Steps:${NC}"
echo ""
echo "1. Start preview server:"
echo -e "   ${BLUE}npm run dev${NC}"
echo ""
echo "2. Create a video:"
echo -e "   ${BLUE}npm run create:video${NC}"
echo ""
echo "3. Render final video:"
echo -e "   ${BLUE}npm run build${NC}"
echo ""
echo -e "${YELLOW}Documentation:${NC}"
echo "  - README.md - Full documentation"
echo "  - QUICK_START.md - Quick start guide"
echo ""
echo -e "${GREEN}Happy video creating! 🎬${NC}"
echo ""
