#include "stdafx.h"
#include "effect.h"

#include "core/device.h"
#include "core/fatalexception.h"
#include "core/err.h"

namespace engine
{
	Effect load_effect(core::Device &device, std::string filename)
	{
		Effect eff;

		ID3DXBuffer *err_buf = 0;
		HRESULT hr = D3DXCreateEffectFromFile(device, filename.c_str(), NULL, NULL, 0, NULL, &eff, &err_buf);

		if (FAILED(hr))
		{
			if (NULL == err_buf) throw core::FatalException(std::string("failed to load mesh \"") + filename + std::string("\"\n\n") + core::d3d_get_error(hr));
			throw core::FatalException(std::string("failed to load mesh \"") + filename + std::string("\"\n\n") + std::string((const char*)err_buf->GetBufferPointer()));
		}

		eff.update();
		return eff;
	}
}